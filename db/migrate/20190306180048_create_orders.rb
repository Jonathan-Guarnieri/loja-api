class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :order_type
      t.references :contact, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
