module SpreeSpringboard
  class ImportProduct
    NAMES = {
      taxonomy: 'color',
      size: 'size',
      season: 'season',
      description: 'short description',
      tax_category: 'default',
      shipping_category: 'Default'
    }.freeze

    def initialize
      create_property(NAMES[:description])
      create_property(NAMES[:season])
      create_option_type(NAMES[:size])
    end

    def import
      # tmp_page = 2049
      # response = api_items(per_page, tmp_page)
      response = api_items(per_page)
      return unless response.success?
      # pages ||= tmp_page
      pages ||= response.body.pages
      save_items(response.body.results)
      # pages.downto(2039).each do |page|
      pages.downto(2).each do |page|
        puts "Page: #{page} of #{pages}"
        response = api_items(per_page, page)
        next unless response.success?
        save_items(response.body.results)
      end
    end

    private

    def per_page
      10
    end

    def api_items(per_page, page = 1)
      SpreeSpringboard.client[:items].query(
        per_page: per_page,
        page: page
      ).get
    end

    def save_items(items)
      items.each do |item|
        # check if master variant exist
        next if item.custom.style_name.blank? || item.custom.style_code.blank? || item.custom[:size].blank?
        variant = variant_exist?(item.custom.style_code)
        # if exist, create new variant for product
        # if not, create new product and master variant
        if variant
          create_variant(variant.product, item)
        else
          create_product(item)
        end
      end
    end

    def create_product(item)
      shipping_category = Spree::ShippingCategory.find_or_create_by(name: NAMES[:shipping_category])
      tax_category = Spree::TaxCategory.find_or_create_by(name: NAMES[:tax_category])
      option_types = Spree::OptionType.where(name: NAMES[:size])
      set_taxonomy(item.custom.color, NAMES[:taxonomy])
      taxons = Spree::Taxon.where(name: item.custom.color)
      price = item.original_price ? item.original_price : 0.00
      product = Spree::Product.create!(
        name: item.custom.style_name,
        description: item.long_description,
        price: price,
        sku: item.custom.style_code,
        weight: item.weight,
        width: item.width,
        height: item.height,
        depth: item.depth,
        cost_price: item.cost,
        shipping_category: shipping_category,
        tax_category: tax_category,
        option_types: option_types,
        taxons: taxons,
        available_on: item.active? ? DateTime.now : nil
      )
      set_product_property(product, item.custom.season, NAMES[:season])
      set_product_property(product, item.description, NAMES[:description])
    end

    def create_variant(product, item)
      set_option_value(item.custom[:size], NAMES[:size])
      variant = variant_exist?(item.public_id)
      variant = new_variant(item, product) unless variant
      variant
    end

    def new_variant(item, product)
      option_values = Spree::OptionValue.where(name: item.custom[:size])
      Spree::Variant.create!(
        sku: item.public_id,
        weight: item.weight,
        width: item.width,
        height: item.height,
        depth: item.depth,
        cost_price: item.cost,
        product: product,
        price: item.original_price,
        option_values: option_values
      )
    end

    def variant_exist?(sku)
      if sku.blank?
        false
      else
        Spree::Variant.find_by(sku: sku)
      end
    end

    def create_option_type(name)
      Spree::OptionType.find_or_create_by(
        name: name,
        presentation: name
      )
    end

    def create_property(name)
      Spree::Property.find_or_create_by(
        name: name,
        presentation: name
      )
    end

    def set_product_property(product, value, property_name)
      return if value.blank?
      property = Spree::Property.find_by(name: property_name)
      return unless property
      create_product_property(product, property, value)
    end

    def create_product_property(product, property, value)
      Spree::ProductProperty.create(
        product: product,
        property: property,
        value: value
      )
    end

    def set_taxonomy(value, taxonomy_name)
      return if value.blank?
      taxonomy = Spree::Taxonomy.find_or_create_by(name: taxonomy_name)
      return unless taxonomy
      set_taxon(taxonomy, value)
    end

    def set_taxon(taxonomy, value)
      Spree::Taxon.find_or_create_by(
        parent: taxonomy.taxons.root,
        taxonomy: taxonomy,
        name: value
      )
    end

    def set_option_value(value, option_name)
      return if value.blank?
      option_type = Spree::OptionType.find_by(name: option_name)
      return unless option_type
      option_value(value, option_type)
    end

    def option_value(value, option_type)
      Spree::OptionValue.find_or_create_by(
        name: value,
        presentation: value,
        option_type: option_type
      )
    end
  end
end
