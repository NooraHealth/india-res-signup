module TurnApi
  class Base < ApplicationService

    attr_accessor :errors, :logger, :parsed_response, :connection, :token, :response

    def initialize(logger)
      self.logger = logger
      self.errors = []
    end

    protected

    def api_method
      :post
    end

    def action_path

    end

    def body_params
      {}
    end

    def setup_connection
      # reading tokens and endpoints from config file
      configs = YAML.load_file("#{Rails.root}/config/turn_api_config.yml").with_indifferent_access

      base_url = configs[:base_url]
      self.token = configs[:token]

      logger = Logger.new $stderr
      logger.level = Logger::DEBUG

      self.connection = Faraday.new(url: base_url) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger, logger # log requests to STDOUT
        faraday.options[:timeout] = 60 # time out is 60 seconds
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
    end

    def execute_api_call
      puts "Endpoint: #{action_path}"
      puts "Request Params are: #{body_params}"
      case api_method
      when :post
        self.response = self.connection.post do |req|
          req.url action_path
          req.body = body_params.to_json
          req["Authorization"] = "Bearer #{self.token}"
          req["Accept"] = "application/json"
          req["Content-Type"] = "application/json"
        end
      when :get
        self.response = self.connection.get do |req|
          req.url action_path
          req.params = body_params
          req["Authorization"] = "Bearer #{self.token}"
          req["Content-Type"] = "application/json"
        end
      else
        self.response = self.connection.post do |req|
          req.url action_path.to_json
          req.body = body_params.to_json
          req["Authorization"] = "Bearer #{self.token}"
          req["Accept"] = "application/+json"
          req["Content-Type"] = "application/json"
        end
      end
      puts "Response status: #{self.response.status}"
      puts "Response body: #{self.response.body}"
    end
  end
end
