App.player = App.cable.subscriptions.create "PlayerChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (partials) ->
    for partial_name, content of partials
      $("#" + partial_name).html(content)
    initGame()
