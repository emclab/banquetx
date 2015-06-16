require 'rails_helper'

module Banquetx
  RSpec.describe Banquet, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:banquetx_banquet)
      expect(c).to be_valid
    end
    
    it "should reject nil date" do
      c = FactoryGirl.build(:banquetx_banquet, :banquet_date => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil time" do
      c = FactoryGirl.build(:banquetx_banquet, :banquet_time => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:banquetx_banquet, :category_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 est_cost" do
      c = FactoryGirl.build(:banquetx_banquet, :cost => 0)
      expect(c).not_to be_valid
    end

    it "should take nil category_id" do
      c = FactoryGirl.build(:banquetx_banquet, :category_id => nil)
      expect(c).to be_valid
    end
    
    it "should reject dup date and time" do
      c = FactoryGirl.create(:banquetx_banquet, :banquet_time => "nil")
      c1 = FactoryGirl.build(:banquetx_banquet, :banquet_time => "Nil", :banquet_date => c.banquet_date, :host_id => c.host_id)
      expect(c1).not_to be_valid
    end
    
  end
end
