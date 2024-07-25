class PictureItem < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :url, uniqueness: { scope: :user_id }
end
