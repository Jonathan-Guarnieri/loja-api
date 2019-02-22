class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :address
      t.string :document
      t.integer :kind

      t.timestamps
    end
  end
end
