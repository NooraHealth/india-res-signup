
module TbRes
  class Base < ApplicationService

    attr_accessor :logger, :errors, :tb_user

    def initialize(logger)
      self.logger = logger
      self.errors = []
    end
  end
end
