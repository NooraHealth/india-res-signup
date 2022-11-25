module Res
  module SubDistrictHospitals
    class Base < ApplicationService

      attr_accessor :logger, :errors, :parsed_exotel_params

      def initialize(logger)
        self.logger = logger
        self.errors = []
      end


      protected

    end
  end
end
