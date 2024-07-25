module V2
  class UsersController < ApplicationController
    before_action :current_user, only: [:update]

    def index
      @users = User.includes(:picture_items).all
    end

    def update
      current_user.update_picture_items(params[:first_pic], params[:urls])
    end
  end
end
