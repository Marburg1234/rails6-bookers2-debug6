class BookComment < ApplicationRecord

  belongs_to :user
  belongs_to :book
  # validate presence → cをsにしないように注意！
  validates :comment, presence: true

end
