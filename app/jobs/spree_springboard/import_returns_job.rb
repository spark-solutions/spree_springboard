module SpreeSpringboard
  class ImprtReturnsJob < ApplicationJob
    queue_as :default

    def perform
      import_manager = SpreeSpringboard::Resource::Import::CustomerReturn.new
      import_manager.import_last_day
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Import New Returns" })
      raise error
    end
  end
end
