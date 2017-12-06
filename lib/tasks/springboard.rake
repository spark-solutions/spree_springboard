namespace :spree do
  namespace :springboard do
    desc 'Export new orders'
    task export_new_orders: :environment do
      SpreeShipstation::ExportNewOrdersJob.perform_now
    end

    desc 'Export shipped orders'
    task export_shipped_orders: :environment do
      SpreeShipstation::ExportShippedOrdersJob.perform_now
    end
  end
end
