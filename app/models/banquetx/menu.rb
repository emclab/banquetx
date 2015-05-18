module Banquetx
  class Menu < ActiveRecord::Base
    attr_accessor :course_name, :last_updated_by_name, :category_name
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :course, :class_name => Banquetx.banquet_course_class.to_s
    belongs_to :banquet, :class_name => 'Banquetx::Banquet'
    #belongs_to :approved_by, :class_name => 'Authentify::User'  
      
    validates :banquet_id, :course_id, :qty, :presence => true, :numericality => {:greater_than => 0, :only_integer => true}    
    validates :course_id, :uniqueness => {:scope => :banquet_id, :message => I18n.t('Duplidate Dish Course!')}
    #validates :approved_by_id, :numbericality => {:greater_than => 0, :only_integer => true}, :if => 'approved_by_id.present?'        
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_menu', 'banquetx_banquet')
      eval(wf) if wf.present?
    end
  end
end
