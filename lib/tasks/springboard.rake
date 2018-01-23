namespace :spree do
  namespace :springboard do
    desc 'Import returns'
    task import_returns: :environment do
      SpreeSpringboard::ImportReturnsJob.perform_now
    end

    desc 'Update variants'
    task update_variants: :environment do
      SpreeSpringboard::UpdateVariantJob.perform_now
    end

    desc 'Inventory Import - Incremental'
    task sync_inventory_incremental: :environment do
      SpreeSpringboard::IncrementalInventoryImportJob.perform_now
    end

    desc 'Inventory Import - Full'
    task sync_inventory_full: :environment do
      SpreeSpringboard::FullInventoryImportJob.perform_now
    end
  end
end
