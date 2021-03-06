module Banquetx
  class Banquet < ActiveRecord::Base
    
    attr_accessor :host_name, :last_updated_by_name, :approved_by_name, :replied_by_name
    
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
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_banquet', 'banquetx_banquet')
      eval(wf) if wf.present?
    end
  end
end
