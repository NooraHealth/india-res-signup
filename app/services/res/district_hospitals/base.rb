module Res
  module DistrictHospitals
    class Base < ApplicationService

      attr_accessor :logger, :errors

      def initialize(logger)
        self.logger = logger
        self.errors = []
      end

    end
  end
end
