require_dependency "banquetx/application_controller"

module Banquetx
  class BanquetsController < ApplicationController
    before_action :require_employee
    before_action :load_records
        
    def index
      @title = t('Banquets')
      @banquets = params[:banquetx_banquets][:model_ar_r]  #returned by check_access_right
      @banquets = @banquets.where(category_id: @category_id) if @category_id
      @banquets = @banquets.where(host_id: @host.id) if @host
      @banquets = @banquets.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('banquet_index_view', 'banquetx')
    end
  
    def new
      @title = t('New Banquet')
      @banquet = Banquetx::Banquet.new()
      @erb_code = find_config_const('banquet_new_view', 'banquetx')
    end
  
    def create
      @banquet = Banquetx::Banquet.new(new_params)
      @banquet.last_updated_by_id = session[:user_id]
      @banquet.booked_by_id = session[:user_id]
      if @banquet.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{menus_path(banquet_id: @banquet.id)}&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('banquet_new_view', 'banquetx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Banquet')
      @banquet = Banquetx::Banquet.find_by_id(params[:id])
      @erb_code = find_config_const('banquet_edit_view', 'banquetx')
    end
  
    def update
      @banquet = Banquetx::Banquet.find_by_id(params[:id])
      @banquet.last_updated_by_id = session[:user_id]
      if @banquet.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('banquet_edit_view', 'banquetx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Banquet Info')
      @banquet = Banquetx::Banquet.find_by_id(params[:id])
      @erb_code = find_config_const('banquet_show_view', 'banquetx')
    end
    
    def destroy
      Banquetx::Banquet.delete(params[:id])
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    
    def load_records
      @host = Authentify::User.find_by_id(params[:host_id].to_i) if params[:host_id].present?
      @host = Authentify::User.find_by_id(Banquetx::Banquet.find_by_id(params[:id].to_i).host_id) if params[:id].present?
      @category_id = params[:category_id].to_i if params[:category_id].present?
    end
    
    private
    
    def new_params
      params.require(:banquet).permit(:banquet_date, :banquet_time, :host_id, :number_of_atendee, :about, :note, :about_atendee, :drink, :less_sodium,
                     :less_fat, :avoid_certain_food, :wf_state, :how_many_table)
    end

    def edit_params
      params.require(:banquet).permit(:banquet_date, :banquet_time, :host_id, :number_of_atendee, :about, :note, :about_atendee, :drink, :less_sodium,
                     :less_fat, :avoid_certain_food, :wf_state, :kitchen_replied, :kitchen_replied_time, :replied_by_id, :approved, :approved_time,
                     :approved_by_id, :feedback, :star_rating, :how_many_table, :cancelled)
    end

  end
end
