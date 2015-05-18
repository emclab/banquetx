require_dependency "banquetx/application_controller"

module Banquetx
  class MenusController < ApplicationController
    before_action :require_employee
    before_action :load_record
        
    def index
      @title = t('Dishes')
      @menus = params[:banquetx_menus][:model_ar_r]  #returned by check_access_right
      @menus = @menus.where(banquet_id: @banquet.id) if @banquet
      @menus = @menus.where(course_id: @course.id) if @course
      @menus = @menus.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('menu_index_view', 'banquetx')
    end
  
    def new
      @title = t('New Dish')
      @menu = Banquetx::Menu.new()
      @erb_code = find_config_const('menu_new_view', 'banquetx')
      @js_erb_code = find_config_const('menu_new_js_view', 'banquetx')
    end
  
    def create
      @menu = Banquetx::Menu.new(new_params)
      @menu.last_updated_by_id = session[:user_id]
      if @menu.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('menu_new_view', 'banquetx')
        @js_erb_code = find_config_const('menu_new_js_view', 'banquetx')
        @banquet = Banquetx::Banquet.find_by_id(params[:menu][:banquet_id])
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Dish')
      @menu = Banquetx::Menu.find_by_id(params[:id])
      @erb_code = find_config_const('menu_edit_view', 'banquetx')
      @js_erb_code = find_config_const('menu_edit_js_view', 'banquetx')
    end
  
    def update
      @menu = Banquetx::Menu.find_by_id(params[:id])
      @menu.last_updated_by_id = session[:user_id]
      if @menu.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('menu_edit_view', 'banquetx')
        @js_erb_code = find_config_const('menu_edit_js_view', 'banquetx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Dish Info')
      @menu = Banquetx::Menu.find_by_id(params[:id])
      @erb_code = find_config_const('menu_show_view', 'banquetx')
    end
    
    def destroy
      Banquetx::Menu.delete(params[:id])
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    
    def load_record
      @banquet = Banquetx::Banquet.find_by_id(params[:banquet_id]) if params[:banquet_id].present?
      @banquet = Banquetx::Banquet.find_by_id(Banquetx::Menu.find_by_id(params[:id]).banquet_id) if params[:id].present?
      @course = Banquetx.banquet_course_class.find_by_id(params[:course_id].to_i) if params[:course_id].present?
      @course = Banquetx.banquet_course_class.find_by_id(Banquetx::Menu.find_by_id(params[:id].to_i).course_id) if params[:id].present?
    end
    
    private
    
    def new_params
      params.require(:menu).permit(:banquet_id, :course_id, :less_sodium, :less_fat, :brief_note, :less_hot, :qty, :wf_state)
    end

    def edit_params
      params.require(:menu).permit(:course_id, :less_sodium, :less_fat, :brief_note, :less_hot, :qty, :wf_state, :approved)
    end

  end
end
