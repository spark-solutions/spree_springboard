Deface::Override.new(
  virtual_path: 'spree/admin/shared/_order_summary',
  insert_bottom: '#order_tab_summary tbody',
  partial: 'spree/admin/shared/order_summary_springboard_export_status',
  name: 'admin_add_springboard_export_status_to_order_summary'
)
