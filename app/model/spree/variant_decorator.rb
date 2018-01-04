module Spree
  Variant.class_eval do
    include SpringboardResources
    self.springboard_import_class = SpreeSpringboard::Resource::Import::Variant

    # Perform variant price import from Springboard
    def self.springboard_import_prices!
      return false unless springboard_import_class.present?

      import_manager = springboard_import_class.new
      import_manager.import_prices!
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Import Variant Prices Error' })
      raise error
    end
  end
end
