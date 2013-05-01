class Todolist < ActiveRecord::Base
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarkers, through: :bookmarks, source: :user
  has_many :todos, dependent: :destroy
  attr_accessible :public, :title

  validates :title, presence: true, length: { maximum: 255 }
  validates :user, presence: true

  def bookmarker?(user)
    bookmarks.find_by_user_id(user.id)
  end
end
