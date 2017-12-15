module SpreeSpringboard
  class ImportReturnsJob < ApplicationJob
    queue_as :default

    def perform
      Spree::ReturnAuthorization.springboard_import_new
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Import New Returns' })
      raise error
    end
  end
end
