module RchPortal
  module Punjab
    class OnboardingController < ApplicationController

      attr_accessor :logger

      skip_forgery_protection

      before_action :initiate_logger

      # TODO - implement token based authentication
      # before_action :authorize_token


      # endpoint for importing records onto our list of RCH records
      def bulk_import_users
        op = RchPortal::Import.(logger, import_params)
        @results = op.results
        if op.errors.present?
          render status: 402, json: {errors: op.errors}
        else
          render status: 200, template: 'rch_portal/punjab/bulk_import_users'
        end
      end

      # this method will take an array of ImportItem ids and give the status for all of them
      def check_import_status

      end


      # this action onboards a single user onto the RCH Program
      # by taking their details in a standardized format and saving it
      # onto the database
      def create
        op = RchPortal::CreateUser.(logger, rch_params)
        if op.errors.present?
          @errors = op.errors
          render 'create_failure'
        else
          @rch_user = op.rch_user
          render 'create_success'
        end
      end


      def update_profile
        op = RchPortal::UpdateRchProfile.(logger, profile_params)
        if op.errors.present?
          logger.warn("Profile update failed with errors: #{op.errors.to_sentence}")
          render json: {errors: op.errors}
        else
          render json: {success: true, user: op.rch_user, rch_profile: op.rch_user.rch_profile}
        end
      end


      # this is an endpoint that will be used to update a user's language through WA
      # # TODO - Abhishek will implement this
      def update_language

      end

      private

      def import_params
        params.permit!
      end

      def rch_params
        params.permit!
      end

      def profile_params
        params.permit!
      end

      def initiate_logger
        self.logger = Logger.new("#{Rails.root}/log/rch/punjab/#{action_name}.log")
        self.logger.info("-------------------------------------")
        logger.info("API parameters are: #{params}")
      end

    end
  end
end
