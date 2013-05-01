class Todo < ActiveRecord::Base
  belongs_to :todolist
  attr_accessible :content, :done

  validates :todolist, presence: true
  validates :content, presence: true, length: { maximum: 500 }
end
