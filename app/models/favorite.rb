class Favorite < ApplicationRecord


  #bookとuserモデルへアソシエートしておく
  # 1:Nの関係⇒1つの投稿に対しいいねを送る 投稿側からみるとたくさんいいねくるk可能性あり
  # 1:Nの関係⇒N側がいいねと考える たくさんの記事に対しいいねを送る
  belongs_to :book
  belongs_to :user

end
