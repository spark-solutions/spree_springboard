module Spree
  ReturnAuthorization.class_eval do
    include SpringboardResources
    self.springboard_import_class = SpreeSpringboard::Resource::Import::ReturnAuthorization

    # Import last day's Returns from Springboard
    def self.springboard_import_last_day!
      return false unless springboard_import_class.present?

      import_manager = springboard_import_class.new
      import_manager.import_last_day!
    rescue StandardError => error
      class_name = name.demodulize.titleize.pluralize
      ExceptionNotifier.notify_exception(error, data: { msg: "Import #{class_name} Error" })
      raise error
    end
  end
end
