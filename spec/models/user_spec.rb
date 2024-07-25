require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create! }
  let(:first_pic) { 'https://example.com/first_pic.jpg' }
  let(:urls) { ['https://example.com/pic1.jpg', 'https://example.com/pic2.jpg'] }

  describe '#update_picture_items' do
    it 'removes existing picture items with URLs not present in the new set' do
      picture_items = [
        { url: 'https://example.com/old_pic.jpg' },
        { url: 'https://example.com/another_old_pic.jpg' }
      ]
      user.picture_items.create(picture_items)

      user.update_picture_items(first_pic, urls)

      expect(user.picture_items.where(url: 'https://example.com/old_pic.jpg')).to be_empty
      expect(user.picture_items.where(url: 'https://example.com/another_old_pic.jpg')).to be_empty
    end

    it "creates new picture items for URLs that don't exist" do
      user.update_picture_items(first_pic, urls)

      expect(user.picture_items.where(url: first_pic)).to exist
      expect(user.picture_items.where(url: urls[0])).to exist
      expect(user.picture_items.where(url: urls[1])).to exist
    end

    it 'marks a picture item as first (if applicable)' do
      user.update_picture_items(first_pic, urls)

      expect(user.picture_items.find_by(url: first_pic).first_pic).to be true
    end

    it 'removes duplicate URLs' do
      urls << 'https://example.com/pic1.jpg'
      urls << 'https://example.com/pic2.jpg'
      user.update_picture_items(first_pic, urls)

      expect(user.picture_items.count).to eq(3)
    end

    it 'keeps existing existing picture items unchanged if those items are present in the new set' do
      existing_pic_url = 'https://example.com/existing_pic1jpg'
      existing_item = user.picture_items.create(url: existing_pic_url)

      user.update_picture_items(first_pic, urls << existing_pic_url)

      expect(user.picture_items.where(url: existing_pic_url).first.url).to eq(existing_item.url)
    end
  end
end
