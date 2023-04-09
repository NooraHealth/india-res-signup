# Parameter formats:
# {
#   "mobile_number":
#   "language":
# }

module RchPortal

  class UpdateLanguage < RchPortal::Base
    include Errors

    def initialize(params)
      @params = params
    end

    def verify_parameters
      @params.require [:mobile_number, :language]

      if not @params[:mobile_number].start_with? "0"
        @params[:mobile_number] = "0" + @params[:mobile_number]
      end
    end

    def get_user_object
      user = User.find_by mobile_number: @params[:mobile_number]

      if user.nil?
        raise UserNotFound.new(@params[:mobile_number])
      else
        user
      end
    end

    def get_language_object
      language = Language.find_by iso_code: @params[:language]

      if language.nil?
        raise LanguageNotFound.new(@params[:language])
      else
        language
      end
    end

    def call

      verify_parameters

      user = get_user_object
      language = get_language_object

      user.update(language_preference: language)
      TextitRapidproApi::UpdateLanguage.(id: user.id)

    end
  end
end
