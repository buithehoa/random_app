class HomeController < ApplicationController
  before_action :current_user, only: [:update_user]

  def index
    users = User.includes(:picture).all

    resp = users.map do |user|
      {
        id: user.id,
        pic: user.picture ? [user.picture.first_pic, user.picture.urls&.split(",")].flatten : []
      }
    end
    render json: resp
  end

  def update_user
    current_user.update_pictures(params[:first_pic], params[:urls])
    current_user.update_picture_items(params[:first_pic], params[:urls])

    render template: 'v2/users/update.json.jbuilder'
  end
end
