Deface::Override.new(virtual_path:  'spree/products/show',
                     insert_after:  'h1.product-title',
                     text:          '<h2 class="sale">On Sale</h2>',
                     name:          'product_sale')