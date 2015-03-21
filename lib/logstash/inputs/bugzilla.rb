# encoding: utf-8
require 'logstash/namespace'
require 'logstash/inputs/base'

require "stud/interval"

require 'bugzilla/bug'
require 'bugzilla/plugin'
require 'bugzilla/product'
require 'bugzilla/user'
require 'bugzilla/xmlrpc'

class LogStash::Inputs::Bugzilla < LogStash::Inputs::Base

  config_name 'bugzilla'
  # This is the name to call inside the input configuration block for the plugin:
  # input {
  #   bugzilla {...}
  # }

  default :codec, 'json'

  # The configuration, or config section allows you to define as many (or as few)
  # parameters as are needed to enable Logstash to process events.
  # There are several configuration attributes:
  #
  # :validate - allows you to enforce passing a particular data type to Logstash 
  #             for this configuration option, such as :
  #               :string, :password, :boolean, :number, :array, :hash,
  #               :path (a file-system path), :codec (since 1.2.0), :bytes (starting in 1.5.0).
  # :default - lets you specify a default value for a parameter
  # :required - whether or not this parameter is mandatory (a Boolean true or false)
  # :deprecated - informational (also a Boolean true or false)

  # Bugzilla server address (FQDN or IP) connect to.
  config :host, :validate => :string, :required => true, :default => "bugzilla.redhat.com"
  # BUgzilla port number connect to.
  config :port, :validate => :number, :required => true, :default => 443
  # URL path for accessing the xmlrpc.cgi file on Bugzilla  server.
  # Example: 'https://bugzilla.redhat.com:443/xmlrpc.cgi'
  config :xmlrpc_path, :validate => :string, :required => true, :default => '/xmlrpc.cgi'
  # Bugzilla user name to use
  config :user, :validate => :string
  # Password for the user name
  config :password, :validate => :string
  # Proxy server address (FQDN or IP) to use for sending requests to Bugzilla
  config :proxy_host, :validate => :string
  # Proxy port number
  config :proxy_port, :validate => :string
  # Timeout for request sent to Bugzilla.
  config :timeout, :validate => :number, :required => true, :default => 60
  # Interval time (in seconds) between update check on Bugzilla.
  config :interval, :validate => :number, :default => 5
  # Search parameters to filter relevant bugs.
  # http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Bug.html#search
  config :search_params, :validate => :hash, :required => true, :default => {'product' => 'Fedora'}


  # Logstash inputs must implement two main methods: register and run.
  # 'public' means the method can be called anywhere, not just within the class.
  # This is the default behavior for methods in Ruby, but it is specified explicitly here anyway.

  # The Logstash register method is like an initialize method.
  public
  def register
    @logger.info("Opening a new connection to Bugzilla server #{@host}:#{@port}#{@xmlrpc_path} With user '#{@user}'")
    @xmlrpc = Bugzilla::XMLRPC.new(@host, @port, @xmlrpc_path, @proxy_host, @proxy_port, @timeout, @user, @password)
    cookie = @xmlrpc.cookie
    @bugzilla = Bugzilla::Bug.new(@xmlrpc)
    @last_check = 0
  end # def register

  # The run method is where a stream of data from an input becomes an event.
  public
  def run(queue)
    Stud.interval(@interval) do
      begin
        time = Time.now
        @logger.debug("Searching from #{@last_check} with params: #{@search_params}")
        add_bugs(queue,'creation_time')
        add_bugs(queue,'last_change_time')
        @last_check = time
      rescue LogStash::ShutdownSignal
        return
      rescue => e
        @logger.error("Bugzilla Error: #{e}")
        retry
      end
    end
  end # def run

  private
  def add_bugs(queue,time_filter)
    begin
      search = @search_params
      search[time_filter] = @last_check
      search['limit'] = 1
      search['offset'] = 0
      begin
        bug = @bugzilla.search(search)['bugs'].first
        event = LogStash::Event.new('@timestamp' => bug[time_filter].to_time, 'host' => @host, 'message' => bug)
        @logger.debug("Addind event: #{event}")
        decorate(event)
        queue << event
        search['offset'] += 1
      end while not @bugzilla.search(search).empty?
    end
  end # def add_created_bugs

end # class LogStash::Inputs::Bugzilla
