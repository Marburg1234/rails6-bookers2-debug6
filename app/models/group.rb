class Group < ApplicationRecord

  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :group_users

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

end
