jQuery(document).on 'turbo:ready', ->
  club_id = $('#chat-box-club-id').val()
  owner_id = $('#owner_id').val()
  if (App.cable.subscriptions['subscriptions'].length > 1)
    App.cable.subscriptions.remove(App.cable.subscriptions['subscriptions'][1])
  App.club = App.cable.subscriptions.create {
    channel: 'ClubChannel'
    club_id: club_id},
    connected: ->

    disconnected: ->

    received: (data) ->
      if owner_id == data.owner_id
        $('#list-messages').append data.message_owner
      else
        $('#list-messages').append data.message
      $('div').animate({scrollTop: $('#viewport-content ul').height()},'slow');

    speak: (message) ->
      @perform 'speak', message: message, club_id: club_id, owner_id: owner_id


  $('#new_message').on 'submit',(event) ->
    event.preventDefault()
    if $('.chat-input').val().length > 0
      App.club.speak($('.chat-input').val())
      $('.chat-input').val('')
