class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from StandardError, with: :render_error

  private

  def current_user
    @current_user ||= User.find(params[:id])
  end

  def render_not_found(exception)
    log_error exception
    render json: { message: exception.message }, status: :not_found
  end

  def render_error(exception)
    log_error exception
    render json: { message: exception.message }, status: :internal_server_error
  end

  def log_error(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join "\n"
  end
end
