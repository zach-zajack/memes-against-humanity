$(document).on "turbolinks:load", ->
  return unless $("#game").length
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
        selectWinner(data.winner)
        setTimeout(refresh_partials, 3000)
      else if data.redirect?
        window.location = "/"
      else if data.message?
        el = $(".messages")[0]
        scroll_down = (el.scrollHeight - el.clientHeight == el.scrollTop)
        $(el).append(data.message)
        el.scrollTop = el.scrollHeight - el.clientHeight if scroll_down
      else
        refresh_partials()

    play_sources: (source_ids) ->
      @perform "play_sources", source_ids: source_ids

    select_meme: (meme_id) ->
      @perform "select_meme", meme_id: meme_id

    message: (content) ->
      @perform "message", content: content
