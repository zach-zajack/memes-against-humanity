class ApplicationController < ActionController::Base
  helper_method :current_player

  def current_player
    @current_player ||= Player.find_by id: cookies.signed[:player_id]
  end
  
  def record_not_found
    raise ActiveRecord::RecordNotFound
  end
end
