class ApplicationsController < ApplicationController

  # new application form
  def new
  end

  # submits the application and renders thanks page
  def create
    ApplyForAccount.perform(params)

    render :thanks
  rescue DeterLab::RequestError => e
    show_form e.message
  rescue DeterLab::Error => e
    show_form t(".unknown_failure")
  end

  private

  def show_form(message)
    flash.now[:alert] = t(".failure", error: message).html_safe
    gon.userType = params[:user_type]
    render :new
  end
end
