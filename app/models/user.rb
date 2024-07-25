class User < ActiveRecord::Base
  has_one :picture
  has_many :picture_items

  # Efficiently updates a user's picture items by:
  # - Removing existing picture items with URLs not present in the new set
  # - Creating new picture items for URLs that don't exist
  # - Marking a picture item as first (if applicable)
  def update_picture_items(first_pic, urls)
    new_urls = [first_pic, urls].compact.flatten.uniq
    existing_urls = self.picture_items.map(&:url)
    urls_to_delete = existing_urls - new_urls

    ActiveRecord::Base.transaction do
      self.picture_items.where(url: urls_to_delete).destroy_all

      new_urls.each do |url|
        self.picture_items.find_or_create_by(url: url)
      end

      self.picture_items.find_by(url: first_pic)&.update(first_pic: true)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error updating pictures: #{e.message}")
    raise
  end

  def update_pictures(first_pic, urls)
    if self.picture.nil? && (first_pic || urls)
      self.create_picture!(
        first_pic: first_pic,
        urls: urls.join(",")
      )
    elsif self.picture.present?
      self.picture.update!(first_pic: first_pic) if first_pic.present?
      self.picture.update!(urls: urls.join(",")) if urls.present?
    end
  end
end
