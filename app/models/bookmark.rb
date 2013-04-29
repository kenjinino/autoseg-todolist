class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :todolist
  # attr_accessible :title, :body
  attr_accessible :todolist_id

  validates :user_id, presence: true
  validates :todolist_id, presence: true
end
