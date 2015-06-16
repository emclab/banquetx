# This migration comes from banquet_coursex (originally 20150428192607)
class CreateBanquetCoursexCourses < ActiveRecord::Migration
  def change
    create_table :banquet_coursex_courses do |t|
      t.string :name
      t.integer :category_id
      t.integer :last_updated_by_id
      t.text :ingredient_spec
      t.string :speciality
      t.float :unit_price
      t.text :note
      t.text :cooking_spec
      t.boolean :available, :default => true
      t.text :comment
      t.integer :good_for_how_many
      t.string :image_name
      t.string :image_location
      t.float :star_rating
      t.string :wf_state
      t.integer :cost

      t.timestamps null: false
    end
    
    add_index :banquet_coursex_courses, :name
    add_index :banquet_coursex_courses, :category_id
    add_index :banquet_coursex_courses, :ingredient_spec
    add_index :banquet_coursex_courses, :cooking_spec
    add_index :banquet_coursex_courses, :wf_state
    add_index :banquet_coursex_courses, :star_rating
  end
end
