module Spree
  module Admin
    class SpringboardLogsController < ResourceController
      def collection
        return @collection if @collection.present?
        params[:q] ||= {}
        if params[:q][:order_id].present?
          @order_number = params[:q][:order_id]
          @order = Spree::Order.find_by_number(@order_number)
          params[:q][:resource_type_or_parent_type_eq] = 'Spree::Order'
          params[:q][:resource_id_or_parent_id_eq] = @order.present? ? @order.id : -1
          params[:q].delete :order_id
        end

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.
                      result.
                      page(params[:page]).
                      per(params[:per_page] || 50)
        @collection
      end
    end
  end
end
