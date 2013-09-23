class Browser
  class Middleware
    class Context
      attr_reader :browser, :request

      def initialize(request)
        @request = request

        @browser = Browser.new(
          ua: request.user_agent,
          accept_language: request.env["HTTP_ACCEPT_LANGUAGE"]
        )
      end

      def redirect_to(path, status=301)
        throw :redirected, {path => path.to_s, :status => status}
      end
    end
  end
end
