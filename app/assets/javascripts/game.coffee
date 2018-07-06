document.addEventListener 'turbolinks:load', ->
  $('.slider-block').slick({
    prevArrow: $("#back")
    nextArrow: $("#next")
    infinite: false
  });
  $('.slider-block').on 'init reInit afterChange', (event, slick, currentSlide, nextSlide) ->
    #currentSlide is undefined on init -- set it to 0 in this case (currentSlide is 0 based)
    i = (if currentSlide then currentSlide else 0) + 1
    $('#number_of_part').attr "data-text", i

  $('#check_btn').click ->
    # Stop all sounds
    stopMusic();
    # Hide slider and clear test_part
    $(".slider-block").hide()
    $(".container.test_part").html()
    # Refresh cards
    cards_refresh();

  SearchForSortable()
  $('.btn-group-vertical .btn').click ->
    level = $(this).attr('data-level')
    if getCookie('level') != level and getCookie('level')
      setCookie 'level', level, 365
      $('.btn-active').removeClass 'btn-active'
      $(this).addClass 'btn-active'
      $('.level-of-difficulty-modal-sm').modal 'hide'
    # Stop all sounds
    stopMusic();
    # Hide slider and clear test_part
    $(".slider-block").hide()
    $(".container.test_part").html()
    # Refresh cards
    cards_refresh();

cards_refresh = ->
  url = window.location.pathname
  test_id = url.substring(url.lastIndexOf('/') + 1)
  test_part = parseInt( $('.slick-current .block-slide').attr("data-test-part") )
  $.ajax
    url: '/cards_refresh/' + test_id
    type: 'get'
    data:
      test_part: test_part
    success: (data) ->
      GenerateTest(JSON.parse(data["cards"]), JSON.parse(data["mixed_cards"]));
      SearchForSortable();
    error: (xhr) ->
      console.log "Ops, smth got wrong("

send_answer = (answer) ->
  url = window.location.pathname
  test_id = url.substring(url.lastIndexOf('/') + 1)
  test_part = parseInt( $('.slick-current .block-slide').attr("data-test-part") )
  $.ajax
    url: '/check_answer'
    type: 'get'
    data:
      user_answer: "[" + answer + "]"
    success: (data) ->
      console.log data
      GenerateAnswer(JSON.parse(data["cards"]), data["errors"])
    error: (xhr) ->
      console.log "Ops, smth got wrong("

SearchForSortable = ->
  cancelRequired = undefined
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
      card_obj = $('.container.test_part > .row:nth-child(2) > .col-2 > ul.target > li')
      wrap_obj = $('.container.test_part > .row:nth-child(2) > .col-2 > ul.target')
      user_answer_array = card_obj.map(->
        $(this).attr 'data-id'
      ).get()
      if card_obj.length == wrap_obj.length
        send_answer user_answer_array
      return
      if cancelRequired
        $(this).sortable 'cancel'
      return
    update: (event, ui) ->
      playSound '/sounds/drop.mp3'
  ).disableSelection()
  return
