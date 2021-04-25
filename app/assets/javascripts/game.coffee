getTestParts = ->
  testPartNumbers = $('.block-slide').map(->
    $(this).data 'test-part'
  ).get()
  return testPartNumbers.reduce (a,b) -> Math.max a, b

document.addEventListener 'turbolinks:load', ->
  history.pushState(null, null, window.location.href)
  mobile = $(window).width() < 768
  Howler.unload()
  $('.slider-block').slick({
    arrows: false
    infinite: false
    waitForAnimate: false
  });
  $(".level, .part_number").TouchSpin({
      min: 1,
      max: getTestParts(),
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
    $('.part_number').trigger(trigger);
  $('.fullscreen').click (event) ->
    fullscreen();
    event.preventDefault();
  $('.play, .auto_play').click ->
    $('.game_zone').removeAttr("data-learning");
    if $(".auto_play").is("[active]")                                           # if user cancels auto mode
      $(this).removeAttr("active");                                             # remove active status
      return                                                                    # break function
    else if $(".play").is("[active]")
      return
    if mobile
      $(".mobile_controll").show()                                              # enable mobile mode
    $(this).attr({active: "active"});
    cards_refresh();
    $('.mobnav').hide();
    $(".test_part, .mobile_info, .notification_holder").show();
    $('#texted_btn, button.btn.btn-secondary.mx-3[data-target=".settings-modal-sm"]').removeClass("mx-3")
    $('.col-6.d-from-md-none').not(".text-right").css("padding", "0 5px")
