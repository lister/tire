module Tire

  module HTTP

    module Client

      class RestClient
        ConnectionExceptions = [::RestClient::ServerBrokeConnection, ::RestClient::RequestTimeout]

        def self.get(url, data=nil)
          perform ::RestClient::Request.execute(:method => :get, :url => url, :payload => data, open_timeout: Configuration.open_timeout)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.post(url, data)
          perform ::RestClient::Request.execute(method: :post, url: url, payload: data, open_timeout: Configuration.open_timeout, timeout: Configuration.timeout )
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.put(url, data)
          perform ::RestClient::Request.execute(method: :put, url: url, payload: data, open_timeout: Configuration.open_timeout, timeout: Configuration.timeout )
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.delete(url)
          perform ::RestClient::Request.execute(method: :delete, url: url, open_timeout: Configuration.open_timeout, timeout: Configuration.timeout )
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.head(url)
          perform ::RestClient::Request.execute(method: :head, url: url, open_timeout: Configuration.open_timeout, timeout: Configuration.timeout )
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        private

        def self.perform(response)
          Response.new response.body, response.code, response.headers
        end

      end

    end

  end

end
