FactoryGirl.define do
  factory :banquetx_banquet, :class => 'Banquetx::Banquet' do
    banquet_date "2015-04-24"
    banquet_time "MyString"
    host_id 1
    last_updated_by_id 1
    number_of_attendee 1
    about "MyString"
    note "MyText"
    about_guest "MyString"
    drink false
    less_sodium false
    less_fat false
    avoid_certain_food "MyString"
    wf_state "MyString"
    kitchen_replied false
    kitchen_replied_time "2015-04-24 12:36:15"
    replied_by_id 1
    approved false
    approved_time "2015-04-24 12:36:15"
    approved_by_id 1
    feedback "MyText"
    booked_by_id 1
  end

end
