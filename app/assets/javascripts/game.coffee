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
    cards_refresh();
    $("#refresh_btn").show()
    $(this).wrap('<a onclick="finish_test(); location.reload();">').parent().html('<i class="fa fa-stop-circle"></i>')

  SearchForSortable()

  $('.btn-group-vertical .btn').click ->
    level = $(this).attr('data-level')
    if getCookie('level') != level and getCookie('level')
      setCookie 'level', level, 365
      $('.btn-active').removeClass 'btn-active'
      $(this).addClass 'btn-active'
      $('.level-of-difficulty-modal-sm').modal 'hide'
    cards_refresh();
