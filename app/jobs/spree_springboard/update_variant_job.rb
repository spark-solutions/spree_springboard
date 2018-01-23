module SpreeSpringboard
  class UpdateVariantdJob < ApplicationJob
    queue_as :springboard

    def perform
      Spree::Variant.springboard_import_attributes!
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Update Variant' })
      raise error
    end
  end
end
