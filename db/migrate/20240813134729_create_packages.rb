class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.string :package_name
      t.decimal :package_price, precision: 3, scale: 2
      t.string :package_description
      t.integer :package_duration
      t.references :venue, null: false, foreign_key: true
      t.timestamps
    end
  end
end
