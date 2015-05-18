FactoryGirl.define do
  factory :banquetx_menu, :class => 'Banquetx::Menu' do
    banquet_id 1
    course_id 1
    less_sodium false
    less_fat false
    brief_note "MyString"
    last_updated_by_id 1
    less_hot false
    qty 1
  end

end
