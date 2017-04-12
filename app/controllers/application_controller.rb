class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def user_utc_offset
    unless timezone_params[:timezone_offset]
      return session[:utc_offset] ||= ActiveSupport::TimeZone['UTC'].formatted_offset
    end

    offset_minutes = timezone_params[:timezone_offset].to_i
    utc_offset = ActiveSupport::TimeZone.seconds_to_utc_offset(offset_minutes * -60)
    session[:utc_offset] = utc_offset
  end

  private

  def timezone_params
    params.permit(:timezone_offset)
  end
end
