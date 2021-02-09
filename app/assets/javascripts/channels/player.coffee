$(document).on "turbolinks:load", ->
  return unless window.location.pathname.match(/\/games\/\d{4}/g)
  App.player = App.cable.subscriptions.create "PlayerChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      refresh_partials = ->
        for partial_name, content of data.partials
          $("#" + partial_name).html(content)
          initGame()

      if data.winner?
        $("#scoreboard").html(data.scoreboard)
        $("[data-player-id='" + data.winner.id + "']").addClass("winner")
        $("[data-meme-id='" + data.winner.meme_id + "']").addClass("winner")
        setTimeout(refresh_partials, 3000)
      else
        refresh_partials()

    play_sources: (source_ids) ->
      @perform "play_sources", source_ids: source_ids

    select_meme: (meme_id) ->
      @perform "select_meme", meme_id: meme_id

    message: (content) ->
      @perform "message", content: content
