class HomeController < ApplicationController
  def index
    now = Time.current.localtime(user_utc_offset)

    @start = now.to_datetime.beginning_of_day
  end
end
