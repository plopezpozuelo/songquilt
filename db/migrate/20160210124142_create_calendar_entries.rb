class CreateCalendarEntries < ActiveRecord::Migration
  def change
    create_table :calendar_entries do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :reason

      t.timestamps null: false
    end
    add_index :calendar_entries, :user_id
    add_index :calendar_entries, :event_id
    add_index :calendar_entries, [:user_id, :event_id], unique: true
  end
end
