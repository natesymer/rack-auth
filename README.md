# Rack::Auth

Rackish authentication for Rack apps.

## Why

There is no simple authentication gem in existence. Current ones implement more than what's required, provide poor access to basic auth data, and have too many dependencies.

While I say this general thing about most software, it rings true for this gem. `rack-auth` provides a simple addition to `Rack::Request` that handles reading the `Authorization` header. Nothing more. `rack-auth` doesn't try to handle persistence, token generation, nor token granting.

`rack/auth` also beats its competitors on amount of code. There's ~60 SLOC in `rack/auth` and closer to 500 for other gems.

## Usage

`rack-auth` uses token handlers to allow a developer to write their own token lookup code.

Token handlers are **optional**, **defined by token type** and **return a hash** containing auth information:
    
    # If a handler is not given
    # Rack::Request#auth will return client-provided
    # auth data in a hash

    Rack::Request::AuthHandlers.bearer do |token|
      # Look up `token`
    end
    
    Rack::Request::AuthHandlers.mac do |token|
      # Look up `token`
    end
    
    # You probably don't need this handler.
    Rack::Request::AuthHandlers.basic do |username, password|
      # Look up username and password
    end
    
You can put handlers *anywhere*, as long as the class variable is assigned before `Rack::Request#auth` is called. I'd put them inside a class definition like below. (You should put it anywhere global/semi-global)
    
    class MyApp
      ### put handlers here
  
      def call env
        [200, {}, ["Hello world!"]]
      end
    end
    
Then you can access auth information on each `Rack::Request`:
    
    r = Rack::Request.new env
    r.auth # gets auth from `authenticator` block
    r.authenticated! # raises TokenPresenceError if auth is nil (invalid)
    r.authenticated?
    
`rack-auth` throws errors:

* `Rack::TokenPresenceError` - The request is unauthorized.
* `Rack::TokenValidityError` - The authorization is bad.

You can catch them and/or use things like Sansom's `Sansomable#error` method or Sinatra's error catching contraption

## Installation

Add this line to your application's Gemfile:

    gem 'rack-auth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-auth

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/sansomrb/rack-auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
