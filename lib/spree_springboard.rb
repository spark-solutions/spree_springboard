require 'spree_core'
require 'spree_springboard/engine'
require 'spree_springboard/gift_card'
require 'spree_springboard/import_product'
require 'spree_springboard/version'
require 'springboard-retail'


module SpreeSpringboard
  class Configuration
    attr_accessor :api
    attr_accessor :token

    def initialize
      @api = @token = ''
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
