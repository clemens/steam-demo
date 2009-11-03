class Task < ActiveRecord::Base
  belongs_to :list

  acts_as_list :scope => :list
  default_scope :order => "done ASC, position ASC"

  def open?
    !done?
  end
end
