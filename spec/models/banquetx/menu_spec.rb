require 'rails_helper'

module Banquetx
  RSpec.describe Menu, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:banquetx_menu)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:banquetx_menu, :qty => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil banquet_id" do
      c = FactoryGirl.build(:banquetx_menu, :banquet_id => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 banquet_id" do
      c = FactoryGirl.build(:banquetx_menu, :banquet_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:banquetx_menu, :qty => 0)
      expect(c).not_to be_valid
    end
    
    it "should take nil course_id" do
      c = FactoryGirl.build(:banquetx_menu, :course_id => nil)
      expect(c).not_to be_valid
    end
    
    it "should take 0 course_id" do
      c = FactoryGirl.build(:banquetx_menu, :course_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject dup course_id" do
      c = FactoryGirl.create(:banquetx_menu)
      c1 = FactoryGirl.build(:banquetx_menu)
      expect(c1).not_to be_valid
    end
    
  
  end
end
