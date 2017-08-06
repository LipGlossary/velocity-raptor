class CalendarController < ApplicationController
  def show
    @today = Time.now.beginning_of_day
  end
end
