class ChangeControlController < ApplicationController

  before_filter :require_login

  # pulls data from the remote link
  def pull
    require 'open-uri'

    url = params[:url]
    if url !~ /^http/
      render text: "Only HTTP URLs are supported", status: 400
      return
    end

    render text: open(url).read
  rescue OpenURI::HTTPError => e
    Rails.logger.error "Failed to pull CC resource '#{params[:url]}': #{e}"
    render text: e.message, status: 500
  end

end
