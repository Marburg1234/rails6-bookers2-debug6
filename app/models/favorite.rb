class Favorite < ApplicationRecord


  #bookとuserモデルへアソシエートしておく
  # 1:Nの関係⇒1つの投稿に対しいいねを送る 投稿側からみるとたくさんいいねくるk可能性あり
  # 1:Nの関係⇒N側がいいねと考える たくさんの記事に対しいいねを送る
  belongs_to :book
  belongs_to :user

  # 通知用のアソシエート
  has_one :notification, as: :notifiable, dependent: :destroy #追記


  # 通知を作成する
  after_create :notify_favorite

  private

  # いいねが起きた時にnotificationにデータを登録するメソッド
  def notify_favorite
    Notification.create(user_id: book.user_id, notifiable: self)
  end

end
