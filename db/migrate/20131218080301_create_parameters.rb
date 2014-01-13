class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :param_name
      t.string :param_value
      t.integer :firm_id

      t.timestamps
    end
  end
end
