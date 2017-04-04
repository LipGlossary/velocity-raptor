class HomeController < ApplicationController
  def index
    # TODO: timezone math

    @start = DateTime.current.beginning_of_day
  end
end
