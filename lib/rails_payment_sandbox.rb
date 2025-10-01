# frozen_string_literal: true

require "rails_payment_sandbox/version"
require "rails_payment_sandbox/gateway"

module RailsPaymentSandbox
  class Error < StandardError; end

  class << self
    attr_accessor :config

    def configure
      self.config ||= {}
      yield(config) if block_given?
    end
  end
end
