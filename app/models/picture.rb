class Picture < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates_uniqueness_of :user_id
end
