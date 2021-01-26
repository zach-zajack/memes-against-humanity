App.player = App.cable.subscriptions.create "PlayerChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (partials) ->
    for partial_name, content of partials
      $("#" + partial_name).html(content)
    initGame()

  play_sources: (source_ids) ->
    @perform "play_sources", source_ids: source_ids

  select_meme: (meme_id) ->
    @perform "select_meme", meme_id: meme_id

  message: (content) ->
    @perform "message", content: content
