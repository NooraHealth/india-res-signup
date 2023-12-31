# this controller and action deals with all actions that have to do with loading users onto
# our backend from the RCH database. We can have a variety of onboarding options - including
# giving an endpoint they can consume, or us having a script that pulls from their API

# This controller deals with ONLY the creation and updation of user. It can also contain update endpoints
# for updating user attributes from various locations

module RchPortal
  module AndhraPradesh
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
          render status: 200, template: 'rch_portal/andhra_pradesh/bulk_import_users'
        end
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

      # this endpoint will handle all link-based signups that happens for users on the RCH portal
      # The link essentially sends users a custom message that triggers a stack on Turn, which will specify
      # the condition area, language and state of the user to onboard them onto the right campaign
      def link_based_signup
        op = RchPortal::LinkBasedSignup.(logger, turn_params)
        if op.errors.present?
          logger.warn("Link based signup failed with errors: #{op.errors.to_sentence}")
          render json: {success:false, errors: op.errors}
        else
          render json: {success: true}
        end
      end


      # this endpoint will handle all onboarding that are based off of IVR
      # Based on the exophone, the relevant program, condition area and language is chosen and users
      # are onboarded onto the specific program based on that
      def ivr_signup
        op = RchPortal::IvrSignup.(logger, exotel_params)
        if op.errors.present?
          logger.warn("IVR Signup failed with the errors: #{op.errors.to_sentence}")
          render json: {errors: op.errors}
        else
          render json: {}
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

      def turn_params
        params.permit!
      end

      def exotel_params
        params.permit!
      end

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
        self.logger = Logger.new("#{Rails.root}/log/rch/andhra_pradesh/#{action_name}.log")
        self.logger.info("-------------------------------------")
        logger.info("API parameters are: #{params}")
      end

    end
  end
end
