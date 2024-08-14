class CreatePackageItems < ActiveRecord::Migration[7.1]
  def change
    create_table :package_items do |t|
      t.string :item_name
      t.decimal :item_price, precision: 3, scale: 2
      t.references :venue, null: false, foreign_key: true
      t.references :booking, null: true, foreign_key: true

      t.timestamps
    end
  end
end
