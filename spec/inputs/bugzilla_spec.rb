# encoding: utf-8
# Add the gem 'logstash-devutils' to Logstash Gemfile (not plugin's Gemfile)
require 'logstash/devutils/rspec/spec_helper'
require 'logstash/inputs/bugzilla'
require 'bugzilla/bug'
require 'bugzilla/plugin'
require 'bugzilla/product'
require 'bugzilla/user'
require 'bugzilla/xmlrpc'
require 'bugzilla/bugzilla'

describe LogStash::Inputs::Bugzilla do |plugin|
  let(:queue) { Queue.new }

  describe '#register' do
    it 'load xmlrpc with default configurations' do
      bugzilla = plugin.new
      expect { bugzilla.register }.not_to raise_error
    end
  end
end
