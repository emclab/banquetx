require 'rails_helper'

module Banquetx
  RSpec.describe MenusController, type: :controller do
    routes {Banquetx::Engine.routes}
    before(:each) do
      #expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
           
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      piece = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "set, piece")
      time_int = FactoryGirl.create(:engine_config, :engine_name => 'banquetx', :engine_version => nil, :argument_name => 'time_interval', :argument_value => "8:00AM, 9:30PM")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @cate = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'banquet_category')
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns menus" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Banquetx::Menu.order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_menu, )
        task1 = FactoryGirl.create(:banquetx_menu, :course_id => task.course_id + 1)
        get 'index'
        expect(assigns(:menus)).to match_array([task1, task])
      end
      
      it "should only return the menus for the banquet" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Banquetx::Menu.order('created_at DESC')")
        session[:user_id] = @u.id
        b =  FactoryGirl.create(:banquetx_banquet)
        task = FactoryGirl.create(:banquetx_menu, :banquet_id => b.id)
        task1 = FactoryGirl.create(:banquetx_menu, :banquet_id => task.banquet_id + 1)
        get 'index', {:banquet_id =>b.id}
        expect(assigns(:menus)).to  match_array([task])
      end
            
    end
  
    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        get 'new', { :category_id => @cate.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        b =  FactoryGirl.create(:banquetx_banquet)
        task = FactoryGirl.attributes_for(:banquetx_menu, banquet_id: b.id )  
        get 'create', {:menu => task}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        b =  FactoryGirl.create(:banquetx_banquet)
        task = FactoryGirl.attributes_for(:banquetx_menu, :qty => nil, banquet_id: b.id)
        get 'create', {:menu => task}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id        
        task = FactoryGirl.create(:banquetx_menu)
        get 'edit', {:id => task.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_menu)
        get 'update', {:id => task.id, :menu => {:qty => 2}}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_menu)
        get 'update', {:id => task.id, :menu => {:course_id => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        c = FactoryGirl.create(:banquet_coursex_course)
        task = FactoryGirl.create(:banquetx_menu, course_id: c.id, :last_updated_by_id => @u.id)
        get 'show', {:id => task.id}
        expect(response).to be_success
      end
    end
    
     describe "Get 'destroy'" do
       it "should destroy" do
         user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource => 'banquetx_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_menu, :last_updated_by_id => @u.id)
        get 'destroy', {:id => task.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
       end
     end

  end
end
