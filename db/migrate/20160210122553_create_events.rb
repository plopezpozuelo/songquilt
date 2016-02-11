class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :kind
      t.string :display_name
      t.string :date
      t.string :time
      t.string :location
      t.string :uri
      t.string :sk_id
      t.string :artist_id

      t.timestamps null: false
    end
    add_index :events, :sk_id, unique:true
  end
end
