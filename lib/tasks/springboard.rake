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

    desc 'Import variants'
    task import_variants: :environment do
      SpreeSpringboard::ImportVariantJob.perform_now
    end

    desc 'Schedule: Import returns'
    task schedule_import_returns: :environment do
      SpreeSpringboard::ImportReturnsJob.perform_later
    end

    desc 'Schedule: Update variants'
    task schedule_update_variants: :environment do
      SpreeSpringboard::UpdateVariantJob.perform_later
    end

    desc 'Schedule: Inventory Import - Incremental'
    task schedule_sync_inventory_incremental: :environment do
      SpreeSpringboard::IncrementalInventoryImportJob.perform_later
    end

    desc 'Schedule: Inventory Import - Full'
    task schedule_sync_inventory_full: :environment do
      SpreeSpringboard::FullInventoryImportJob.perform_later
    end

    desc 'Schedule: Import variants'
    task import_variants: :environment do
      SpreeSpringboard::ImportVariantJob.perform_later
    end
  end
end
