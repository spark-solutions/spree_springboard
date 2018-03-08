Spree::Admin::OrdersController.class_eval do
  def springboard_export
    @order = Spree::Order.find_by_number(params[:id])
    if !@order.can_springboard_export?
      flash[:error] = Spree.t(:cannot_export_to_springboard)
    else
      springboard_id = @order.springboard_export!
      if springboard_id.present?
        flash[:success] = Spree.t(:springboard_export_successful)
      else
        flash[:error] = Spree.t(:springboard_export_error)
      end
    end

    redirect_back fallback_location: spree.edit_admin_order_url(@order)
  end
end
