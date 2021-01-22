App.game = App.cable.subscriptions.create {
    channel: "GameChannel",
    join_code: window.location.pathname.substr(7) # /games/:join_code
  },

  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

  play_source: (data) ->
    @perform "play_source", source_id: data

  select_meme: (data) ->
    @perform "select_meme", meme_id: data

  message: (data) ->
    @perform "message", content: data
