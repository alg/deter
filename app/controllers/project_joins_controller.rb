class ProjectJoinsController < ApplicationController

  before_filter :require_login

  # Shows project join form
  def new
  end

  # Submits the request to join the project
  def create
    if DeterLab.join_project(app_session.current_user_id, params[:project_id])
      redirect_to :project_joins, notice: t(".success")
    else
      flash.now.alert = t(".failure")
      render :new
    end
  rescue DeterLab::RequestError => e
    show_form e.message
  rescue DeterLab::Error => e
    show_form t(".unknown_failure")
  end

  private

  def show_form(message)
    flash.now[:alert] = t(".failure", error: message).html_safe
    render :new
  end

end
