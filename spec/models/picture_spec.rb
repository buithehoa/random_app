require 'rails_helper'

RSpec.describe Picture, type: :model do
  let(:user) { User.create! }
  let(:picture) { Picture.new(user: user, first_pic: 'https://example.com/first_pic.jpg', urls: 'https://example.com/pic1.jpg,https://example.com/pic2.jpg') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
