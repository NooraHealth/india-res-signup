module Errors
  class ErrorResponse < StandardError
    attr_accessor :data, :status

    def initialize(error, code, status)
      super(error)
      # logger = Logger.new("#{Rails.root}/log/dh/#{action_name}.log")

      dirname = "#{Rails.root}/log/"
      FileUtils.mkdir_p dirname

      logger = Logger.new("#{dirname}/error-response.log")
      logger.warn(error)

      @data = {:error => error, :code => code}
      @status = status
    end
  end

  class LanguageNotFound < ErrorResponse
    def initialize(language)
      super("Language '#{language}' not found", "NO_LANG", 404)
    end
  end

  class UserNotFound < ErrorResponse
    def initialize(mobile_number)
      super("User '#{mobile_number}' not found", "NO_USER", 404)
    end
  end
end
