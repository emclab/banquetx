module Banquetx
  include Authentify::AuthentifyUtility
  require 'workflow'
  class Banquet < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('banquet_wf_pdef', 'banquetx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf) 
      elsif Rails.env.test?  
        state :initial_state do
          event :submit, :transitions_to => :acknowledging
        end
        state :acknowledging do
          event :acknowledge, :transitions_to => :acknowledged
        end
        state :acknowledged
        
      end
    end
  
    attr_accessor :host_name, :last_updated_by_name, :approved_by_name, :replied_by_name, :wf_comment, :wf_state_noupdate, :wf_event, :id_noupdate
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :host, :class_name => 'Authentify::User'
    belongs_to :replied_by, :class_name => 'Authentify::User'
    belongs_to :approved_by, :class_name => 'Authentify::User'  
      
    validates :host_id, :banquet_date, :banquet_time, :presence => true
    validates :host_id, :numericality => {:greater_than => 0, :only_integer => true}
    validates :banquet_time, :uniqueness => {:scope => [:host_id, :banquet_date], :case_sensitive => false, :message => I18n.t('Duplidate Host!')}
    validates :replied_by_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'replied_by_id.present?'        
    validates :approved_by_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'approved_by_id.present?'  
    validates :category_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'category_id.present?'       
    validates :cost, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'cost.present?'       
    validate :dynamic_validate 
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_banquet_' + self.wf_event, 'banquetx') if self.wf_event.present?
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end          
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_banquet', 'banquetx_banquet')
      eval(wf) if wf.present?
    end
  end
end
