class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.float :purchase_price
      t.float :sale_price
      t.integer :amount

      t.timestamps
    end
  end
end
