FactoryGirl.define do
  factory :banquet_coursex_course, :class => 'BanquetCoursex::Course' do
    name "MyString"
    category_id 1
    last_updated_by_id 1
    ingredient_spec "MyText"
    speciality "MyString"
    unit_price 1.5
    note "MyText"
    cooking_spec "MyText"
    available true
    comment "MyText"
    good_for_how_many 1
    image_name "MyString"
    image_location "MyString"
  end

end
