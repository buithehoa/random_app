require 'rails_helper'

RSpec.describe PictureItem, type: :model do
  let(:user) { User.create! }
  let(:picture_item) { PictureItem.new(user: user, url: 'https://example.com/pic.jpg') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:url).scoped_to(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end

