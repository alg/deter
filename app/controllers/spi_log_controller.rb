class SpiLogController < ApplicationController

  layout "spi_log"

  def index
    @records = REDIS.lrange("spi_log", 0, 10)
  end

end
