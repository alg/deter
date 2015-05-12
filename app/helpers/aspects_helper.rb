module AspectsHelper

  def aspect_data(a)
    a.custom_data || a.data
  end

end
