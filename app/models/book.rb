class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # 通知用のアソシエート
  has_many :notifications, as: :notifiable, dependent: :destroy #追記

  # validatesの設定
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  # 通知を作成する
  after_create :notify_followers



  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  private

  def notify_followers
    user.followers.each do |follower|
      Notification.create(user_id: follower.id, notifiable: self)
    end
  end



end
