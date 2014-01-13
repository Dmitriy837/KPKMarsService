class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.text :description
      t.integer :license_count
      t.integer :user_id

      t.timestamps
    end
  end
end
