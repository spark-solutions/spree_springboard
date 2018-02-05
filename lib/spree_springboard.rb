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
    attr_accessor :station_id

    def initialize
      @api = @token = ''
      @station_id = nil
    end
  end

  class << self
    attr_accessor :client
    attr_accessor :configuration
    attr_accessor :springboard_state

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)

      self.client ||= Springboard::Client.new(configuration.api, token: configuration.token)
      self.springboard_state ||= Spree::SpreeSpringboardConfiguration.new
    end
  end
end
