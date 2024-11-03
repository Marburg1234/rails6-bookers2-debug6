class Group < ApplicationRecord

  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :group_users
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true, length: { in: 2..20 }
  validates :introduction, presence: true, length: { in: 2..100 }

  has_one_attached :group_image


  public

  def get_group_image
    if group_image.attached?
      group_image
    else
      'no_image.jpg'
    end
  end

  def group_users_count
    group_users.count
  end

  def already_group_join
    if group_users.exist(current_user)
      true
    else
      false
    end
  end

end
