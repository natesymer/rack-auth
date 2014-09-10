#!/usr/bin/env ruby

require "rack"
require "base64"

module Rack
  TokenPresenceError = Class.new StandardError
  TokenValidityError = Class.new StandardError
  class Request
    class AuthHandlers
      TOKENS = [:basic, :bearer, :mac].freeze
      NIL_BLOCK = lambda { |*_| nil }.freeze
      
      def self.blocks
        @@blocks ||= nil
        @@blocks = {} if @@blocks.nil?
        @@blocks
      end
      
      def self.method_missing meth, *args, &block
        super unless TOKENS.include? meth
        blocks[meth] = block
      end
      
      def self.[] type
        return NIL_BLOCK unless TOKENS.include? type
        blocks[type] || NIL_BLOCK
      end
      
      def self.reset!
        blocks.clear
      end
      
      def self.delete! type
        blocks.delete type
      end
    end
    
	  def auth
      return @auth if @auth
      return nil if @env["HTTP_AUTHORIZATION"].to_s.empty?

      type, token = @env["HTTP_AUTHORIZATION"].split(" ", 2).map(&:strip)
      type = type.strip.downcase.to_sym
      
      raise TokenValidityError, "Invalid token type." unless AuthHandlers::TOKENS.include? type
      raise TokenValidityError, "Authorization data cannot have a zero length." if token.empty?
      
      args = case type
      when :bearer, :mac then { "token" => token }
      when :basic then Hash[["username","password"].zip(Base64.decode64(token).split(":"))]
      end
      
      @auth ||= AuthHandlers[type].call(*args.values) || args
	  end
    
    def authenticated?
      !auth.nil?
    end
  
	  def authenticated!
			raise TokenPresenceError, "No valid token provided." if auth.nil?
	    auth
	  end
  end
end