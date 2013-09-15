class CreateShortMessages < ActiveRecord::Migration
  def change
    create_table :short_messages do |t|
      t.string :source
      t.string :target
      t.string :content
      t.string :msg_type
      t.string :uid
      t.string :udh

      t.timestamps
    end
  end
end
