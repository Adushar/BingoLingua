document.addEventListener 'turbolinks:load', ->
  $('#next').click ->
    alert "22"
    App.cards_refresh.speak({test_id: gon.test_id, level_dafault: gon.level_dafault})
    return
  $('.btn-group-vertical .btn').click ->
    level = $(this).attr('data-level')
    if getCookie('level') != level and getCookie('level')
      setCookie 'level', level, 365
      $('.btn-active').removeClass 'btn-active'
      $(this).addClass 'btn-active'
      $('.level-of-difficulty-modal-sm').modal 'hide'
    return
  $ ->
    cancelRequired = undefined
    $('.connectedSortable').sortable(
      connectWith: '.connectedSortable'
      receive: (event, ui) ->
        if $(this).children().length > 1
          $(ui.sender).sortable 'cancel'
        return
      over: (event, ui) ->
        if $(this).children().length > 1
          $(ui.placeholder).css 'display', 'none'
        else
          $(ui.placeholder).css 'display', ''
        return
      beforeStop: (event, ui) ->
        cancelRequired = $(this).children().length > 1
        return
      stop: ->
        if cancelRequired
          $(this).sortable 'cancel'
        return
      update: (event, ui) ->
        playSound '/sounds/drop.mp3'
        return
    ).disableSelection()
    return
  return
