json.array!(@users, root: false) do |user|
  json.id user.id
  json.pictures user.picture_items.order(first_pic: :desc).map(&:url)
end
