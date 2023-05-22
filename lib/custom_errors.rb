module CustomErrors
  class ErrorResponse < StandardError
    attr_accessor :data, :status

    def initialize(error, code, status, action, controller)
      super(error)
      # logger = Logger.new("#{Rails.root}/log/dh/#{action_name}.log")

      dirname = "#{Rails.root}/log/#{controller}_#{action}"
      FileUtils.mkdir_p dirname

      logger = Logger.new("#{dirname}")
      logger.warn(error)

      @data = {:error => error, :code => code}
      @status = status
    end
  end

  class LanguageNotFound < ErrorResponse
    def initialize(language, action, controller)
      super("Language '#{language}' not found", "NO_LANG", 404, action, controller)
    end
  end

  class UserNotFound < ErrorResponse
    def initialize(mobile_number, action, controller)
      super("User '#{mobile_number}' not found", "NO_USER", 404, action, controller)
    end
  end
end
