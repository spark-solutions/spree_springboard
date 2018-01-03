module Spree
  GiftCard.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::Export::GiftCard
    self.springboard_import_class = SpreeSpringboard::Resource::Import::GiftCard

    after_create_commit :schedule_springboard_export
    after_update_commit :schedule_springboard_adjust_balance

    def self.springboard_import_by_code(code)
      return if code.blank?
      springboard_import_class.import_from_springboard_by_code(code)
    end

    def schedule_springboard_adjust_balance
      return if current_value_before_last_save == current_value
      SpreeSpringboard::UpdateGiftCardJob.perform_later(self)
    end

    def schedule_springboard_export
      SpreeSpringboard::ExportGiftCardJob.perform_later(self)
    end

    def spree_adjust_balance!
      springboard_import_class.new.adjust_balance!(self)
    end

    def springboard_adjust_balance!
      springboard_export_class.new.adjust_balance!(self)
    end
  end
end
