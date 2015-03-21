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

describe 'inputs/bugzilla' do
  context 'registration' do
    it 'can register and tear down with default configurations' do
      input = LogStash::Plugin.lookup('input', 'bugzilla').new
      expect { input.register }.to_not raise_error
      expect { input.teardown }.to_not raise_error
    end
  end
end
