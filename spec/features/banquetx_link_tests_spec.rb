require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /banquetx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
         'left-span#'         => '6', 
         'offset#'         => '2',
         'form-span#'         => '4'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      time_int = FactoryGirl.create(:engine_config, :engine_name => 'banquetx', :engine_version => nil, :argument_name => 'time_interval', :argument_value => "8:00AM, 9:30PM,4:00PM")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])

      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
                                       :sql_code => "Banquetx::Banquet.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
                                       :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
                                       :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
                                       :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
                                       :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Banquetx::Menu.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
       user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      
      visit authentify.new_session_path
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login' 
    end
    it "works for menu" do
      course = FactoryGirl.create(:banquet_coursex_course, :name => 'dish name')
      task = FactoryGirl.create(:banquetx_menu, :last_updated_by_id => @u.id, course_id: course.id)
      visit banquetx.menus_path
      expect(page).to have_content('Dishes')
      click_link 'Edit'
      expect(page).to have_content('Update Dish')
      #fill_in 'menu_course_id', :with => 'a test Course'
      select('dish name', from: :menu_course_id)
      
    end
    it "works! for banquet" do
      task = FactoryGirl.create(:banquetx_banquet, cancelled: false, :last_updated_by_id => @u.id, banquet_time: '4:00PM')
      course = FactoryGirl.create(:banquet_coursex_course, :name => 'dish name')
      visit banquetx.banquets_path
      expect(page).to have_content('Banquets')
      click_link 'Menu'
      expect(page).to have_content('Dishes')
      visit banquetx.banquets_path
      click_link 'Edit'
      expect(page).to have_content('Update Banquet')
      fill_in 'banquet_banquet_date', with: '2008-01-01'
      #save_and_open_page
      click_button 'Save'
      visit banquetx.banquets_path
      #save_and_open_page
      expect(page).to have_content('2008/01/01')
      #with wrong data
      visit banquetx.banquets_path
      click_link 'Edit'
      fill_in 'banquet_banquet_date', with: '2009-01-01'
      select('', from: 'banquet_banquet_time')
      click_button 'Save'
      visit banquetx.banquets_path
      expect(page).not_to have_content('2009-01-01')
      
      #new
      visit banquetx.banquets_path
      click_link 'New Banquet'
      fill_in 'banquet_banquet_date', :with => '2018/05/10'
      select('8:00AM', from: 'banquet_banquet_time')
      click_button 'Save'
      save_and_open_page
      visit banquetx.banquets_path
      expect(page).not_to have_content('2018/05/10')
      #bad data
      visit banquetx.banquets_path
      click_link 'New Banquet'
      fill_in 'banquet_banquet_date', :with => ''
      select('9:30PM', from: 'banquet_banquet_time')
      click_button 'Save'
      visit banquetx.banquets_path
      expect(page).not_to have_content('9:30PM')
      
      #show      
      visit banquetx.banquets_path
      click_link task.id.to_s
      #save_and_open_page
      expect(page).to have_content('Banquet Info')
           
    end
    
  end
end
