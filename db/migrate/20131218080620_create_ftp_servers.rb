class CreateFtpServers < ActiveRecord::Migration
  def change
    create_table :ftp_servers do |t|
      t.string :url
      t.integer :port
      t.string :username
      t.string :password
      t.integer :firm_id

      t.timestamps
    end
  end
end
