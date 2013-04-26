class Todolist < ActiveRecord::Base
  belongs_to :user
  attr_accessible :public, :title

  validates :title, presence: true, length: { maximum: 255 }
  validates :user, presence: true
end
