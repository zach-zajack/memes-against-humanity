module GamesHelper
  def player_classes(player)
    return "czar"    if player.czar?
    return "playing" if player.playing?
    return "winner"  if player.winner?
  end
end
