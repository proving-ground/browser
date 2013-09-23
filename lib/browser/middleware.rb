require "uri"

class Browser
  class Middleware
    attr_reader :env

    def initialize(app, &block)
      raise ArgumentError, "Browser::Middleware requires a block" unless block

      @app = app
      @block = block
    end

    def call(env)
      @env = env
      request = Rack::Request.new(env)

      redirect_options = catch(:redirected) do
        Context.new(request).instance_eval(&@block)
      end

      redirect_options ? resolve_redirection(request.path, redirect_options) : run_app!
    end

    def resolve_redirection(current_path, redirect_options)
      uri = URI.parse(redirect_options[:path])

      if uri.path == current_path
        run_app!
      else
        redirect(redirect_options)
      end
    end

    def redirect(redirect_options)
      [redirect_options[:status], {"Content-Type" => "text/html", "Location" => redirect_options[:path]}, []]
    end

    def run_app!
      @app.call(env)
    end
  end
end
