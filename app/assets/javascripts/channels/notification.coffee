App.notification = App.cable.subscriptions.create 'NotificationChannel',
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    current_user = parseInt($(".current-user-id").val())
    if data.lists_received != null && data.lists_received.includes(current_user)
      $('#notification-top').prepend data.notification
      size_unread = parseInt($('.size_unread').text()) + 1
      $('.size_unread').text(size_unread)
  push: ->
    @perform 'push'
