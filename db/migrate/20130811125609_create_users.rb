class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :mobile_no
      t.string :firstname
      t.string :lastname
      t.string :verification_code
      t.string :verification_expired_at
      t.string :email
      t.string :slug

      t.timestamps
    end

    add_index :users, :username, :unique => true
    add_index :users, :slug, :unique => true
  end
end
