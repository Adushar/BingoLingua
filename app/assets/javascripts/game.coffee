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

  $('.check_btn').click ->
    cards_refresh();
    $("#refresh_btn").show()
    $('.check_btn').removeClass('check_btn')
    $('#iconed_btn').wrap('<a onclick="finish_test(); location.reload();">').parent().html('<i class="fa fa-stop-circle"></i>')
    $("#texted_btn").wrap('<a onclick="finish_test(); location.reload();">').html('Stop')
    $('#texted_btn, button.btn.btn-secondary.mx-3[data-target=".level-of-difficulty-modal-sm"]').removeClass("mx-3")
    $('.col-6.d-from-md-none').not(".text-right").css("padding", "0 5px")

  SearchForSortable()

  $('.btn-group-vertical .btn').click ->
    level = $(this).attr('data-level')
    if getCookie('level') != level and getCookie('level')
      setCookie 'level', level, 365
      $('.btn-active').removeClass 'btn-active'
      $(this).addClass 'btn-active'
      $('.level-of-difficulty-modal-sm').modal 'hide'
    cards_refresh();
