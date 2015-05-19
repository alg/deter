class ExperimentAspectsController < ApplicationController

  before_filter :require_login
  before_filter :load_experiment
  before_filter :require_owner, only: :destroy

  class Aspect < Hashie::Dash
    property :name
    property :type, default: 'layout'
    property :data

    attr_reader :aspect_errors

    def to_spi_data
      { name: self.name, type: self.type, data: self.data.nil? ? nil : Base64.encode64(self.data) }
    end

    def valid_aspect?
      if self.type == 'visualization' && !valid_url?
        @aspect_errors = [ "Invalid URL. Please verify." ]
        false
      else
        @aspect_errors = []
        true
      end
    end

    def valid_url?
      uri = URI.parse(self.data)
      return false unless uri.kind_of?(URI::HTTP)

      Faraday.head(self.data).status != 404
    rescue URI::InvalidURIError
      false
    rescue Faraday::Error
      false
    end

  end

  # new aspect form
  def new
    @change_control_enabled ||= '0'
    @change_control_url     ||= ''
    @aspect                 ||= Aspect.new(type: params[:type])
    configure_new_gon
    render @aspect.type == 'visualization' ? :new_visualization : :new
  end

  # creates the aspect and adds it to the experiment
  def create
    @aspect = Aspect.new(aspect_params)
    @change_control_enabled = params['change_control_enabled']
    @change_control_url = params['change_control_url']

    if !@aspect.valid_aspect?
      raise DeterLab::Error, @aspect.aspect_errors.join(",")
    end

    res = DeterLab.add_experiment_aspects(current_user_id, @experiment.id, [ @aspect.to_spi_data ]).first[1]
    if res[:success]
      deter_lab.invalidate_experiment(@experiment.id)
      ActivityLog.for_experiment(@experiment.id).add("new-aspect-#{@aspect.type}", current_user_id)

      set_aspect_xa(@aspect)

      redirect_to experiment_path(@experiment.id), notice: t('.success')
    else
      flash.now.alert = res[:reason]
      new
    end
  rescue DeterLab::Error => e
    flash.now.alert = e.message
    new
  end

  # edits the aspect
  def edit
    @aspect = @experiment.aspects.find { |a| a.name == params[:id] }
    if @aspect.nil?
      redirect_to experiment_path(@experiment.id), alert: t("experiment_aspects.not_found")
    else
      @change_control_enabled = @aspect.xa['change_control_enabled']
      @change_control_url     = @aspect.xa['change_control_url']
      configure_edit_gon
      render @aspect.type == 'visualization' ? :edit_visualization : :edit
    end
  end

  # updates the aspect data
  def update
    @aspect = @experiment.aspects.find { |a| a.name == params[:id] }
    @change_control_url     = params[:change_control_url]
    @change_control_enabled = params[:change_control_enabled]

    if @aspect.nil?
      redirect_to experiment_path(@experiment.id), alert: t("experiment_aspects.not_found")
    else
      success = false
      new_data = params[:aspect][:data]
      if @aspect.raw_data != new_data

        # Saving custom data as XA
        @aspect.custom_data = new_data

        # res = DeterLab.change_experiment_aspects(current_user_id, @experiment.id, @experiment.aspects)[params[:id]]
        res = { success: true }
        if success = res[:success]
          ActivityLog.for_experiment(@experiment.id).add("updated-aspect-#{@aspect.type}", current_user_id)
          redirect_to experiment_path(@experiment.id), notice: t(".success") #, notice: t(".unimplemented")
        else
          @error = res[:error] || t(".unknown_error")
          configure_edit_gon
          render @aspect.type == 'visualization' ? :edit_visualization : :edit
        end
      else
        success = true
        redirect_to experiment_path(@experiment.id), notice: t(".success")
      end

      if success
        @aspect.change_control_enabled = @change_control_enabled
        @aspect.change_control_url     = @change_control_url
        @aspect.last_updated_at        = Time.now
        @aspect.last_updated_by        = current_user_id
      end
    end
  end

  # removes the member record
  def destroy
    res = DeterLab.remove_experiment_aspects(current_user_id, @experiment.id, [
      { name: params[:id], type: params[:type] }
    ])

    options = {}
    if res[params[:id]]
      options[:notice] = t(".success")
      ActivityLog.for_experiment(@experiment.id).add("deleted-aspect-#{params[:type]}", current_user_id)
      deter_lab.invalidate_experiment(@experiment.id)
    else
      options[:alert] = t(".failure")
    end

    redirect_to experiment_path(@experiment.id), options
  end

  private

  def load_experiment
    @experiment = deter_lab.get_experiment(params[:experiment_id])
  end

  def require_owner
    unless @experiment.owner == @app_session.current_user_id
      redirect_to experiment_path(params[:experiment_id]), alert: t("experiment_members.owner_only")
    end
  end

  def configure_new_gon
    gon.updated_by    = nil
    gon.updated_at    = nil
    configure_gon
  end

  def configure_edit_gon
    last_updated_by   = @aspect.last_updated_by
    gon.updated_by    = last_updated_by.present? ? "#{last_updated_by} (#{user_name(last_updated_by)})" : nil
    gon.updated_at    = @aspect.last_updated_at
    configure_gon
  end

  def configure_gon
    gon.user_name     = "#{current_user_id} (#{current_user_name})"
    gon.pull_url      = cc_pull_url
  end

  def aspect_params
    params[:aspect].permit(:name, :type, :data).symbolize_keys
  end

  def set_aspect_xa(aspect)
    asp = ExperimentAspect.new(@experiment.id, aspect.name, :type, :sub_type, :raw_data, :data_reference)
    asp.last_updated_at        = Time.now
    asp.last_updated_by        = current_user_id
    asp.change_control_enabled = @change_control_enabled
    asp.change_control_url     = @change_control_url
  end

end
