App.cards_refresh = App.cable.subscriptions.create "CardsRefreshChannel",
  connected: ->
    console.log "connected"
  disconnected: ->
    console.log "disconnected"
  received: (data) ->
    console.log(data);
  speak: (data) ->
    @perform 'speak', data: data


# GenerateTest($("block_slide_1 .block-slide"), gon.cards, gon.selected, gon.numer_of_cards);
