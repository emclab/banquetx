require "banquetx/engine"

module Banquetx
  mattr_accessor :banquet_course_class
  
  def self.banquet_course_class
    @@banquet_course_class.constantize
  end
end
