class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :visit_counts, dependent: :destroy


  # ============フォローする・している側からの視点==========
  # フォローする側の情報についての紐づけ
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  # activeを通して、フォローされる人の情報を取得する⇒source:followerになる
  has_many :followings, through: :active_relationships, source: :followed

  # # ========================================================

  # # ==========フォロワー側の視点・フォローされる方================================
  # Railsの命名規則の観点から、followed→followers(単数形⇒複数形)として認識してくれる
  # フォローされる側の情報についての紐付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  # passiveを通して、フォローしてくるユーザー情報を取得⇒source: :followingになる
  has_many :followers, through: :passive_relationships, source: :following

  # DM機能のアソシエート
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms

  # 通知用のアソシエート
  has_many :notifications, dependent: :destroy


  #画像をUserモデルで取り扱う
  has_one_attached :profile_image

  #validate機能：空欄や文字制限を設ける
  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }




  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def followed_by?(user)
    # 今自分が(引数のユーザー)がフォローしようとしているユーザー(受け側)がフォローしているかどうかを判別する
    passive_relationships.find_by(following_id: user.id).present?
    # byebug
  end

  # ゲストログインに必要なguestメソッドを定義する
  # find_or_create_byは、データの検索と作成を自動で判断する→今回は指定してるemailがない→新規作成につながる
  # SecureRandomメソッド⇒ランダムで文字列を生成してくれるRubyのメソッド
  # Modelでemailで検索→メールアドレスない→新規登録→passwordは適当なやつ+名前はguestuserで登録するという設定をしている
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end


  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
        @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end
