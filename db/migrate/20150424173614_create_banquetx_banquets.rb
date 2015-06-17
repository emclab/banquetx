class CreateBanquetxBanquets < ActiveRecord::Migration
  def change
    create_table :banquetx_banquets do |t|
      t.date :banquet_date
      t.string :banquet_time
      t.integer :host_id
      t.integer :last_updated_by_id
      t.integer :number_of_attendee
      t.string :about
      t.text :note
      t.string :about_attendee
      t.boolean :drink
      t.boolean :less_sodium
      t.boolean :less_fat
      t.string :avoid_certain_food
      t.string :wf_state
      t.boolean :kitchen_replied
      t.datetime :kitchen_replied_time
      t.integer :replied_by_id
      t.boolean :approved
      t.datetime :approved_time
      t.integer :approved_by_id
      t.text :feedback
      t.float :star_rating
      t.boolean :cancelled, :default => false
      t.integer :how_many_table
      t.integer :category_id
      t.integer :booked_by_id
      t.integer :cost

      t.timestamps null: false
    end
    
    add_index :banquetx_banquets, :host_id
    add_index :banquetx_banquets, :banquet_date
    add_index :banquetx_banquets, :star_rating
    add_index :banquetx_banquets, :wf_state
    add_index :banquetx_banquets, :approved
    add_index :banquetx_banquets, :kitchen_replied
    add_index :banquetx_banquets, :cancelled
    add_index :banquetx_banquets, :category_id
    add_index :banquetx_banquets, :booked_by_id
  end
end
