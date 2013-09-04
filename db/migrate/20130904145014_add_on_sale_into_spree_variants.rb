class AddOnSaleIntoSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :on_sale, :boolean, default: false
  end
end
