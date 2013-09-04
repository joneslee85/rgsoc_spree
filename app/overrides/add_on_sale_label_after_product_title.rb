Deface::Override.new(virtual_path:  'spree/products/show',
                     insert_after:  'h1.product-title',
                     partial:       'products/on_sale_label',
                     name:          'product_sale')