#!/usr/bin/env ruby

require_relative "./spec_helper.rb"

describe Rack::Request do
  context "when reading auth information" do
    context "with a handler" do
      it "reads basic auth headers" do
        Rack::Request::AuthHandlers.basic { |username, password| { "this" => "that" } }
        expect(@basic.authenticated?).to be_truthy
        expect(@basic.auth).to_not be_empty
        expect(@basic.auth["this"]).to eq("that")
        Rack::Request::AuthHandlers.delete! :basic
      end
      
      it "reads OAuth 2 (bearer) auth headers" do
        Rack::Request::AuthHandlers.bearer { |token| { "this" => "that" } }
        expect(@bearer.authenticated?).to be_truthy
        expect(@bearer.auth).to_not be_empty
        expect(@bearer.auth["this"]).to eq("that")
        Rack::Request::AuthHandlers.delete! :bearer
      end
    end
    
    context "without a handler" do
      it "reads basic auth headers" do
        expect(@basic.authenticated?).to be_truthy
        expect(@basic.auth).to_not be_empty
      end
    
      it "reads OAuth 2 (bearer) auth headers" do
        expect(@bearer.authenticated?).to be_truthy
        expect(@bearer.auth).to_not be_empty
      end
    end
  end
end