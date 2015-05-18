class CreateBanquetxMenus < ActiveRecord::Migration
  def change
    create_table :banquetx_menus do |t|
      t.integer :banquet_id
      t.integer :course_id
      t.boolean :less_sodium
      t.boolean :less_fat
      t.string :brief_note
      t.integer :last_updated_by_id
      t.boolean :less_hot
      t.integer :qty
      t.string :wf_state
      t.boolean :approved
      t.integer :approved_by_id
      t.date :approved_date

      t.timestamps null: false
    end
    
    add_index :banquetx_menus, :banquet_id
    add_index :banquetx_menus, :course_id
    add_index :banquetx_menus, [:banquet_id, :course_id]
    add_index :banquetx_menus, :wf_state
  end
end
