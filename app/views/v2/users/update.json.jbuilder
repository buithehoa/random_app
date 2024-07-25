json.id @current_user.id
json.pictures @current_user.picture_items.order(first_pic: :desc).map(&:url)
