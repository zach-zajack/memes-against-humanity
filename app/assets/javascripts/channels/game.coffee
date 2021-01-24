App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

  play_sources: (source_ids) ->
    console.log(source_ids)
    @perform "play_sources", source_ids: source_ids

  select_meme: (meme_id) ->
    @perform "select_meme", meme_id: meme_id

  message: (content) ->
    @perform "message", content: content
