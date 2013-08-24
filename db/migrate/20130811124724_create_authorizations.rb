class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.string :link
      t.string :image
      t.string :token
      t.string :secret 

      t.timestamps
    end
  end
end
