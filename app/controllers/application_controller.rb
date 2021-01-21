class ApplicationController < ActionController::Base
  def record_not_found
    raise ActiveRecord::RecordNotFound
  end
end
