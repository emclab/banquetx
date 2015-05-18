require 'rails_helper'

module Banquetx
  RSpec.describe BanquetsController, type: :controller do
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
      it "returns banquets" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Banquetx::Banquet.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_banquet, :cancelled => false)
        task1 = FactoryGirl.create(:banquetx_banquet, :about => 'a new task', :banquet_time => 'a new time')
        get 'index'
        expect(assigns(:banquets)).to match_array([task1, task])
      end
      
      it "should only return the course for a category_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Banquetx::Banquet.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_banquet, :category_id => @cate.id)
        task1 = FactoryGirl.create(:banquetx_banquet, :category_id => @cate.id + 1, :about => 'a new task', :banquet_time => 'a new time')
        get 'index', {:category_id => @cate.id}
        expect(assigns(:banquets)).to  match_array([task])
      end
            
    end
  
    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        get 'new', { :category_id => @cate.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.attributes_for(:banquetx_banquet, :category_id => @cate.id )  
        get 'create', {:banquet => task, :category_id => @cate.id}
        #expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=1&url=#{menus_path(banquet_id: banquet.id)}&msg=Successfully Saved!")
        expect(flash[:notice]).to eq('Successfully Saved!')
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.attributes_for(:banquetx_banquet, :category_id => @cate.id, :banquet_date => nil)
        get 'create', {:banquet => task}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        
        task = FactoryGirl.create(:banquetx_banquet, :category_id => @cate.id)
        get 'edit', {:id => task.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_banquet, :category_id => @cate.id)
        get 'update', {:id => task.id, :banquet => {:about => 'new name'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_banquet)
        get 'update', {:id => task.id, :banquet => {:banquet_date => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_banquet, :category_id => @cate.id, :last_updated_by_id => @u.id)
        get 'show', {:id => task.id}
        expect(response).to be_success
      end
    end
    
     describe "Get 'destroy'" do
       it "should destroy" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource => 'banquetx_banquets', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquetx_banquet, :last_updated_by_id => @u.id)
        get 'destroy', {:id => task.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
       end
     end

  end
end
