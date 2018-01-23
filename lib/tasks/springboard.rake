namespace :spree do
  namespace :springboard do
    desc 'Export new orders'
    task export_new_orders: :environment do
      SpreeSpringboard::ExportOrderJob.perform_now
    end

    desc 'Export shipped orders'
    task export_shipped_orders: :environment do
      SpreeSpringboard::InvoiceOrderJob.perform_now
    end

    desc 'Import returns'
    task import_returns: :environment do
      SpreeSpringboard::ImportReturnsJob.perform_now
    end

    desc 'Update variants'
    task update_variants: :environment do
      SpreeSpringboard::UpdateVariantJob.perform_now
    end
  end
end
