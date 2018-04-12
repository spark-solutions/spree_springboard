Deface::Override.new(
  virtual_path: 'spree/admin/payment_methods/_form',
  insert_bottom: '[data-hook="payment_method"]',
  name: 'add_sprinboard_id_to_payment_method_form',
  partial: 'spree/admin/shared/springboard_id_field_in_row'
)

Deface::Override.new(
  virtual_path: 'spree/admin/stock_locations/_form',
  insert_bottom: '[data-hook="stock_location_names"]',
  name: 'add_sprinboard_id_to_stock_location_form',
  partial: 'spree/admin/shared/springboard_id_field'
)

Deface::Override.new(
  virtual_path: 'spree/admin/stock_locations/_form',
  insert_bottom: '[data-hook="stock_location_names"]',
  name: 'add_sprinboard_station_id_to_stock_location_form',
  partial: 'spree/admin/shared/springboard_station_id_field'
)

Deface::Override.new(
  virtual_path: 'spree/admin/payment_methods/_braintree_vzero_form',
  insert_bottom: '[data-hook="admin_payment_method_form_fields"] .panel:first-child .panel-body',
  name: 'add_sprinboard_id_to_braintree_payment_method_form',
  partial: 'spree/admin/shared/braintree_springboard_id_field'
)

Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  insert_bottom: '[data-hook="admin_shipping_method_form_fields"] .row:first-child',
  name: 'add_sprinboard_id_to_shipping_method_form',
  partial: 'spree/admin/shared/springboard_id_field_in_row'
)

Deface::Override.new(
  virtual_path: 'spree/admin/variants/_form',
  name: 'add_sprinboard_id_to_variant_form',
  insert_bottom: '[data-hook="variants"]',
  partial: 'spree/admin/shared/springboard_id_field'
)

Deface::Override.new(
  virtual_path: 'spree/admin/users/_form',
  name: 'add_sprinboard_id_to_user_form',
  insert_bottom: '[data-hook="admin_user_form_fields"]',
  partial: 'spree/admin/shared/customer_springboard_id'
)


