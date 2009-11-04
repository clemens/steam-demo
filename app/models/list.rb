class List < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  acts_as_list
  default_scope :order => "position ASC"
end
