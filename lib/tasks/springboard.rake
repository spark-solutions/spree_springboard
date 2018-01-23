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
  end
end
