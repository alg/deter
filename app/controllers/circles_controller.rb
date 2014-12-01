class CirclesController < ApplicationController

  before_filter :require_login

  def index
    @circles = deter_cache.fetch "user_circles", 30.minutes do
      []
    end
  end

end
