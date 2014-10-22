class ApplicationsController < ApplicationController

  # new application form
  def new
  end

  # submits the application and renders thanks page
  def create
    # TODO submit application

    render :thanks
  end

end
