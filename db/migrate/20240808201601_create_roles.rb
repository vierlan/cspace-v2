class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.uuid :entity_id

      t.timestamps
    end
  end
end
