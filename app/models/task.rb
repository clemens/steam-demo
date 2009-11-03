class Task < ActiveRecord::Base
  belongs_to :list

  acts_as_list :scope => :list
  default_scope :order => 'position ASC'
end
