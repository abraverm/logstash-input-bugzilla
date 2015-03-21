# encoding: utf-8
# rubocop:disable Style/ClassAndModuleChildren, Rails/Date, Rails/TimeZone
require 'logstash/namespace'
require 'logstash/inputs/base'
require 'stud/interval'
require 'bugzilla/bug'
require 'bugzilla/plugin'
require 'bugzilla/product'
require 'bugzilla/user'
require 'bugzilla/xmlrpc'

# Logstash input plugin for pulling bugs from Bugzilla server
class LogStash::Inputs::Bugzilla < LogStash::Inputs::Base
  config_name 'bugzilla'
  milestone 1
  # This is the name to call inside the input configuration block for the
  # plugin:
  #
  #   input {
  #     bugzilla {...}
  #   }

  default :codec, 'json'

  # The configuration, or config section allows you to define as many
  # parameters as are needed to enable Logstash to process events.
  # There are several configuration attributes:
  #
  # :validate - allows you to enforce passing a particular data type to
  #   Logstash for this configuration option.
  # :default - lets you specify a default value for a parameter
  # :required - whether or not this parameter is mandatory (Boolean)
  # :deprecated - informational (also a Boolean true or false)

  # Bugzilla server address (FQDN or IP) connect to.
  config :host,
         validate: :string,
         required: true,
         default: 'bugzilla.redhat.com'
  # BUgzilla port number connect to.
  config :port,
         validate: :number,
         required: true,
         default: 443
  # URL path for accessing the xmlrpc.cgi file on Bugzilla  server.
  # Example: 'https://bugzilla.redhat.com:443/xmlrpc.cgi'
  config :xmlrpc_path,
         validate: :string,
         required: true,
         default: '/xmlrpc.cgi'
  # Bugzilla user name to use
  config :user,
         validate: :string
  # Password for the user name
  config :password,
         validate: :string
  # Proxy server address (FQDN or IP) to use for sending requests to Bugzilla
  config :proxy_host,
         validate: :string
  # Proxy port number
  config :proxy_port,
         validate: :string
  # Timeout for request sent to Bugzilla.
  config :timeout,
         validate: :number,
         required: true,
         default: 60
  # Interval time (in seconds) between update check on Bugzilla.
  config :interval,
         validate: :number,
         default: 5
  # Search parameters to filter relevant bugs.
  # http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Bug.html#search
  config :search_params,
         validate: :hash,
         required: true,
         default: { product: 'Atomic' }

  # Logstash inputs must implement two main methods: register and run.
  # 'public' means the method can be called anywhere, not just within the class.
  # This is the default behavior for methods in Ruby, but it is specified
  # explicitly here anyway.

  # The Logstash register method is like an initialize method.

  public

  def register
    @logger.info('Opening a new connection to Bugzilla server ' \
                 "#{@host}:#{@port}#{@xmlrpc_path} With user '#{@user}'")
    @xmlrpc = Bugzilla::XMLRPC.new(@host, @port, @xmlrpc_path, @proxy_host,
                                   @proxy_port, @timeout, @user, @password)
    @xmlrpc.cookie
    @bugzilla = Bugzilla::Bug.new(@xmlrpc)
    @last_check = 0
  end # def register

  # The run method is where a stream of data from an input becomes an event.

  public

  def run(queue)
    Stud.interval(@interval) do
      begin
        time = Time.now
        add_bugs(queue, init_search('creation_time'), 'creation_time')
        add_bugs(queue, init_search('last_change_time'), 'last_change_time')
        @last_check = time
      rescue LogStash::ShutdownSignal
        return
      end
    end
  end # def run

  private

  def add_bugs(queue, search, time_filter)
    loop do
      begin
        add_event(queue, get_bug(search), time_filter)
        search['offset'] = search['offset'] + 1
        break if @bugzilla.search(search).empty?
      rescue => e
        @logger.error("Bugzilla Error: #{e}")
        retry
      end
    end
  end # def add_created_bugs

  private

  def init_search(time_filter)
    search = @search_params
    search[time_filter] = @last_check
    search['limit'] = 1
    search['offset'] = 0
    search
  end

  private

  def add_event(queue, bug, time_filter)
    event = LogStash::Event.new(
      '@timestamp' => bug[time_filter].to_time,
      'host' => @host,
      'message' => bug)
    @logger.debug("Addind event: #{event}")
    decorate(event)
    queue << event
  end

  private

  def get_bug(search)
    @bugzilla.search(search)['bugs'].first
  end
end # class LogStash::Inputs::Bugzilla
