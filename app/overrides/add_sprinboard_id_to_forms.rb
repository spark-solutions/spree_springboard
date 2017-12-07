Deface::Override.new(
  virtual_path: "spree/admin/payment_methods/_form",
  insert_bottom: '[data-hook="payment_method"]',
  name: "add_sprinboard_id_to_payment_method_form",
  partial: "spree/admin/shared/springboard_id_field"
)

Deface::Override.new(
  virtual_path: "spree/admin/payment_methods/_braintree_vzero_form",
  insert_bottom: '[data-hook="admin_payment_method_form_fields"] .panel:first-child .panel-body',
  name: "add_sprinboard_id_to_braintree_payment_method_form",
  partial: "spree/admin/shared/braintree_springboard_id_field"
)

Deface::Override.new(
  virtual_path: "spree/admin/shipping_methods/_form",
  insert_bottom: '[data-hook="admin_shipping_method_form_fields"] .row:first-child',
  name: "add_sprinboard_id_to_shipping_method_form",
  partial: "spree/admin/shared/springboard_id_field"
)
