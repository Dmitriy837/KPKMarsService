class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :imei
      t.integer :last_date
      t.integer :firm_id

      t.timestamps
    end
  end
end
