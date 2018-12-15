class CreateEventsAndBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :scheduled_time
      t.integer :period, null: false, default: 0
      t.integer :duration, null: false, default: 15.minutes
      t.string :title, null: false

      t.timestamps
    end

    create_table :blocks do |t|
      t.string :type, index: true
      t.references :event, foreign_key: true
      t.integer :start_time, null: false
      t.integer :duration
      t.string :title

      t.timestamps
    end
  end
end
