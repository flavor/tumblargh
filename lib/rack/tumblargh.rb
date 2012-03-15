module Rack
  class Tumblargh
    Tumblargh = ::Tumblargh

    def initialize(app, options={})
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if should_parse?(status, headers)
        headers.delete('Content-Length')
        response = Rack::Response.new(
          render(response.respond_to?(:body) ? response.body : response),
          status,
          headers
        )
        response.finish
        response.to_a
      else
        [status, headers, response]
      end
    end

  private

    def should_parse?(status, headers)
      status == 200 && 
      headers["Content-Type"] && 
      headers["Content-Type"].include?("text/html")
    end

    def render(content)
      Tumblargh::render_html(content.first, 'willw.tumblr.com')
    end

  end
end
