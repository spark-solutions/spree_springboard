require 'spree_core'
require 'spree_springboard/engine'
# require 'spree_springboard/gift_card'
# require 'spree_springboard/import_product'
# require 'spree_springboard/version'
require 'springboard-retail'

module SpreeSpringboard
  class Configuration
    attr_accessor :api
    attr_accessor :token
    attr_accessor :source_location_id
    attr_accessor :station_id
    attr_accessor :payment_type_id_credit_card
    attr_accessor :payment_type_id_paypal
    attr_accessor :payment_type_id_store_credit
    attr_accessor :payment_type_id_gift_card

    def initialize
      @api = @token = ''
      @source_location_id = nil
      @station_id = nil
      @payment_type_id_credit_card = nil
      @payment_type_id_paypal = nil
      @payment_type_id_store_credit = nil
      @payment_type_id_gift_card = nil
    end
  end

  class << self
    attr_accessor :configuration
    attr_accessor :client
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)

      self.client = Springboard::Client.new(
        configuration.api,
        token: configuration.token
      )
    end
  end
end
