# base controller for all RES onboarding controllers

module ResOnboarding
  class Base < ApplicationController

    attr_accessor :logger

    skip_forgery_protection

    before_action :initiate_logger

  end
end
