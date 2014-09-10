#!/usr/bin/env ruby

require "rspec"

module Setup
  require_relative File.dirname(File.dirname(__FILE__)) + "/lib/rack/auth.rb"
  require "rack"
  require "stringio"
  
  def auth_env auth_str
    @env = {
      "HTTP_AUTHORIZATION" => auth_str,
      "CONTENT_TYPE" => "text/plain",
      "QUERY_STRING" => "",
      "REQUEST_METHOD" => "GET",
      "REQUEST_PATH" => "/",
      "REQUEST_URI" => "/",
      "HTTP_HOST" => "localhost:2000",
      "SERVER_NAME" => "localhost",
      "SERVER_PORT" => "2000",
      "PATH_INFO" => "/",
      "rack.url_scheme" => "http",
      "rack.input" => StringIO.new
    }
  end
end

RSpec.configure do |c|
  c.include Setup
  c.before :each do
    @basic = Rack::Request.new auth_env("Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
    @bearer = Rack::Request.new auth_env("Bearer d6503c9fdd3ee788cd749eee130f0927")
  end
end