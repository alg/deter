class LibrariesController < ApplicationController

  before_filter :require_login

  # lists libraries
  def index
  end

  # shows the library
  def show
    eid = params[:id]
    @library = deter_lab.view_libraries.find { |l| l.libid == eid }
    if @library.nil?
      redirect_to :dashboard, alert: t(".not_found")
      return
    end

    gon.libraryDetailsUrl = details_library_path(eid)
  end

  # renders details about library experiments
  # called by JS from the library/show page
  def details
    lid = params[:id]
    @experiments = get_library_experiments_details(lid)
    render json: {
      experiments_html: render_to_string(partial: "shared/details_experiments")
    }
  end

  private

  def get_library_experiments_details(lid)
    SummaryLoader.library_experiments(deter_cache, current_user_id, lid).map do |e|
      { id:     e.id,
        owner:  { id: e.owner, name: user_name(e.owner) },
        descr:  deter_lab.get_experiment_profile(e.id)['description'].try(:value),
        status: 'TBD'
      }
    end
  end

end
