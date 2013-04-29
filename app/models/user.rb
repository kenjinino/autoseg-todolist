class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :todolists, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_todolists, through: :bookmarks, source: :todolist

  def bookmarked?(todolist)
    bookmarks.find_by_todolist_id(todolist.id)
  end

  def bookmark!(todolist)
    bookmarks.create!(todolist_id: todolist.id)
  end

  def unbookmark!(todolist)
    bookmarks.find_by_todolist_id(todolist.id).destroy
  end
end
