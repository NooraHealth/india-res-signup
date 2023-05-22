# Parameter formats:
# {
#   "mobile_number":
#   "language":
# }

module RchPortal

  class UpdateLanguage < RchPortal::Base
    include Errors
    
    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def call

      verify_parameters

      user = get_user_object
      language = get_language_object

      user.update(language_preference: language)
      TextitRapidproApi::UpdateLanguage.(id: user.id)

    end

    private

    def verify_parameters
      self.params.require [:mobile_number, :language]

      unless self.params[:mobile_number].start_with? "0"
        self.params[:mobile_number] = "0" + self.params[:mobile_number]
      end
    end


    def get_user_object
      user = User.find_by mobile_number: self.params[:mobile_number]

      if user.nil?
        raise UserNotFound.new(self.params[:mobile_number], self.params[:action], self.params[:controller])
      else
        user
      end
    end


    def get_language_object
      language = Language.find_by iso_code: self.params[:language]

      if language.nil?
        raise LanguageNotFound.new(self.params[:language], self.params[:action], self.params[:controller])
      else
        language
      end
    end

  end
end
