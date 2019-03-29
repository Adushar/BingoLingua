document.addEventListener 'turbolinks:load', ->
  mobile = $(window).width() < 768
  $('.slider-block').slick({
    arrows: false
    infinite: false
    waitForAnimate: false
  });
  $(".level, .part_number").TouchSpin({
      min: 1,
      max: 4,
      buttondown_class: 'btn btn-default',
      buttonup_class: 'btn btn-default',
      stepinterval: 1000
  });
  $(".level").on 'change', ->
    level = this.value
    console.log $(this).val()
    $(".level").val(level)
    if level == "4"
      alert("☆Now you are playing with selected cards☆")
    setCookie 'level', level, 365
    return
  $(".part_number").on 'touchspin.on.stopspin', ->
    console.log $(this).val()-1
    $('.slider-block').slick( 'slickGoTo', $(this).val()-1 );
    return
  $('.slider-block').on 'swipe', (event, slick, direction) ->
    trigger = if direction == "left" then "touchspin.uponce" else "touchspin.downonce"
    $('#part_number').trigger(trigger);
  $('.fullscreen').click (event) ->
    fullscreen();
    event.preventDefault();
  $('.play, .auto_play').click ->
    if $(".auto_play").attr("active")                                           # if user cancels auto mode
      $(this).removeAttr("active");                                             # remove active status
      return                                                                    # break function
    else if $(".play").attr("active")
      return
    if mobile
      $(".mobile_controll").show()                                              # enable mobile mode
    $(this).attr({active: "active"});
    cards_refresh();
    $('.mobnav').hide();
    $(".test_part, .mobile_info, .notification_holder").show();
    $('#texted_btn, button.btn.btn-secondary.mx-3[data-target=".settings-modal-sm"]').removeClass("mx-3")
    $('.col-6.d-from-md-none').not(".text-right").css("padding", "0 5px")

  $('.btn-group-vertical .btn').click ->
    level = $(this).attr('data-level')
    if getCookie('level') != level and getCookie('level')
      setCookie 'level', level, 365
      $('.btn-active').removeClass 'btn-active'
      $(this).addClass 'btn-active'
      $('.settings-modal-sm').modal 'hide'
    location.reload();

  # mobile hints
  if $(".mobile_controll").length && getCookie('hint') != "false"
    $( "body" ).append('<div class="hint" onclick="$(\'.hint\').remove();setCookie(\'hint\', false, 25)"><img src="/swipe-helper.gif"></div>')
