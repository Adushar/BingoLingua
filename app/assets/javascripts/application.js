// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap
//= require jquery.slick
//= require jquery.fittext.js
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require js/jquery.bootstrap-touchspin
//= require js/odometer.min
//= require js/bootstrap-notify.min
//= require turbolinks
//= require_tree .
//= require popper

var game_key;

$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return results[1] || 0;
    }
}

var bootstrap_error = function(text) {
  html = `<div class="alert alert-warning alert-dismissible fade show" role="alert">
  `+text+`
    <button aria-label="Close" class="close" data-dismiss="alert" type="button">
      <span aria-hidden="true">×</span>
    </button>
  </div>`
  $(html).insertAfter("nav.navbar")
  if (text.includes("☆")) {
    $(".fa.fa-star-o.star").delay( 1000 ).attr(
      'style',
      `-webkit-animation: blink-2 1.5s both !important;
      animation: blink-2 1.5s both !important;`
    )
    setTimeout(function() {
      $(".fa.fa-star-o.star").removeAttr("style");
    }, 1500);
  }
}

var playlist = function(audio_arr, onPlay, data, endFunc, e) {
  // initialisation:
    pCount = 0;
    playlistUrls = audio_arr, // audio list
    howlerBank = [],
    volume = 1,
    loop = false;

  // playing i+1 audio (= chaining audio files)
  var onEnd = function(e) {
    if (loop === true ) { pCount = (pCount + 1 !== howlerBank.length)? pCount + 1 : 0; }
    else { pCount = pCount + 1; }
    if (audio_arr.length == pCount) {
      SearchForSortable();
    }
    setTimeout(function(){
      if (howlerBank[pCount]) {howlerBank[pCount].play()};
      if (endFunc) {endFunc();}
    }, 1000);
  };

  // build up howlerBank:
  playlistUrls.forEach(function(current, i) {
    howlerBank.push(new Howl({ urls: [playlistUrls[i]], onend: onEnd, onplay: onPlay, buffer: true, volume: volume }))
  });
  // initiate the whole :
  howlerBank[0].play();
}

var equalize = function() {
  var maxWidth;
  maxWidth = 0;
  $('.test_part .ui-sortable').each(function() {
    if ($(this).width() > maxWidth) {
      maxWidth = $(this).width();
    }
  });
  $('.test_part .col > ul').width(maxWidth);
};

function stopMusic() {
  var sound = document.getElementById("delete_me");
  if (typeof howlerBank !== 'undefined') {
    howlerBank.forEach(function(obj) {
      obj.stop();
    });
  }
  if (sound) {
    sound.pause();
  }
}

function playSound(soundfile) {
  $("#delete_me").remove();
  setTimeout(function(){
    $('body').append('<audio id="delete_me" src="' + soundfile + '" autostart="false" preload="none" ></audio>');
    $("#delete_me")[0].play();
  }, 150);
};

SearchForSortable = function() {
  var cancelRequired;
  cancelRequired = void 0;
  cancelRequired = void 0;
  $('.connectedSortable').sortable({
    connectWith: '.connectedSortable',
    receive: function(event, ui) {
      if ($(this).children().length > 1) {
        $(ui.sender).sortable('cancel');
      }
    },
    over: function(event, ui) {
      if ($(this).children().length > 1) {
        $(ui.placeholder).css('display', 'none');
      } else {
        $(ui.placeholder).css('display', '');
      }
    },
    beforeStop: function(event, ui) {
      cancelRequired = $(this).children().length > 1;
    },
    stop: function() {
      var card_obj, user_answer_array, wrap_obj;
      card_obj = $('.container.test_part > .row:nth-child(2) > .col > ul.target > li');
      wrap_obj = $('.container.test_part > .row:nth-child(2) > .col > ul.target');
      user_answer_array = card_obj.map(function() {
        return $(this).attr('data-id');
      }).get();
      if (card_obj.length === wrap_obj.length) {
        send_answer(user_answer_array);
      }
      return;
      if (cancelRequired) {
        $(this).sortable('cancel');
      }
    },
    update: function(event, ui) {
      return playSound('/sounds/drop.mp3');
    }
  }).disableSelection();
  // equalize();
};

cards_refresh = function() {
  var test_id, test_part, url;
  url = window.location.pathname;
  test_id = url.substring(url.lastIndexOf('/') + 1);
  test_part = parseInt($('.slick-current .block-slide').attr("data-test-part"));
  console.log("----------cards_refresh----------");
  $("#refresh_btn").hide();
  $("#refresh_txt_btn").remove();
  return $.ajax({
    url: '/cards_set/' + test_id,
    type: 'get',
    data: {
      test_part: test_part
    },
    dataType: "json",
    success: function(data) {
      game_key = data["answer"]
      console.log(data);
      stopMusic();
      $(".slider-block").hide();                                                // Hide slider
      $(".container.test_part").html();                                         // And clean test block
      GenerateTest(game_key, data["game"]);       // Fill test block with new content
    },
    error: function(xhr) {
      var errors = $.parseJSON(xhr.responseText).errors
      bootstrap_error(errors)                                                   // Render error for user
      return false;                                                             // And finish ajax request
    }
  });
};

// IMPORTANT functions for test blocks
function GenerateTest(cards, random_cards) {
  var obj = ".container.test_part"
  var row = $('<div />').attr('class','row');
  var empty_row = $('<div />').attr('class','row');
  var check_row = $('<div />').attr('class','row example');
  var only_sound_array = cards.map(function(item){return item.sound;});
  console.log("GenerateTest");
  playlist(
    only_sound_array,
    function(e) {$('.container.test_part > .row:nth-child(2) > .col:nth-child('+(pCount+1)+') .target').addClass("temp_black");
  });
  $.each( random_cards, function( index, value ) {
    var current_ul_li = '<div class="col"><ul class="connectedSortable"><li class="ui-state-default"  data-id="'+value.id+'"><img src="'+value.picture+'"></li></ul></div>';
    var empty_ul_li = '<div class="col"><ul class="connectedSortable target"></ul></div>'
    var example_ul_li = '<div class="col"><ul class="exampleSortable target"></ul></div>'
    $(row).append(current_ul_li);
    $(empty_row).append(empty_ul_li);
    $(check_row).append(example_ul_li);
  });
  $(obj).html(row);
  $(obj).append(empty_row);
  $(obj).append(check_row);
}

send_answer = function(answer) {
  var test_id, test_part, url;
  url = window.location.pathname;
  test_id = url.substring(url.lastIndexOf('/') + 1);
  test_part = parseInt($('.slick-current .block-slide').attr("data-test-part"));
  console.log("send_answer");
  return $.ajax({
    url: '/check_answer/' + test_id,
    type: 'get',
    data: {
      user_answer: answer
    },
    success: function(data) {
      points_notice(JSON.parse(data["points"]))
      return GenerateAnswer(game_key, data["errors"]);
    },
    error: function(xhr) {
      var errors = $.parseJSON(xhr.responseText).errors
      bootstrap_error(errors)                                                   // Render error for user
      return false;                                                             // And finish ajax request
    }
  });
};

function GenerateAnswer(cards, errors) {
  var only_sound_array = cards.map(function(x){return x["sound"];});
  stopMusic();
  console.log("GenerateAnswer");
  playlist(
    only_sound_array,
    function(e) {
      var image_url = cards[pCount]["picture"]
      var current_li = '<li class="ui-state-default position-relative"><img src="'+image_url+'"><p class="full-width text-capitalize">'+decodeURIComponent(image_url.match(/([^\/]+)(?=\.\w+$)/)[0]);+'</p></li>';
      var answer_row = $('.row:nth-child(2) > .col > ul.target > li.ui-state-default').eq(pCount)
      var success_img = '<i class="fa fa-check img_over good" aria-hidden="true"></i>';
      var fail_img = '<i class="fa fa-times img_over bad" aria-hidden="true"></i>';

      $('.connectedSortable').sortable('disable');
      if (errors && errors[pCount] != null) {
        answer_row.append(fail_img);
        console.log(errors[pCount]);
      } else {
        answer_row.append(success_img);
        console.log(true);
      }
      $('.row.example > .col > ul.target').eq(pCount).html(current_li);
    }, null, function(e) {
      if (pCount == cards.length) {
        setTimeout(function() {
          if ($('#auto_play[active="active"]')[0]) { cards_refresh(); }         // If auto mode is ON, refresh
          $("#texted_btn.play.btn").removeAttr("active");
          $(".col-6.d-from-md-none:first-of-type").append('<a onclick="cards_refresh();"><button class="btn btn-success" id="refresh_txt_btn" type="button">Reset</button></a>')
        }, 1000);
      }
    }
  );
}

// Here is standart cookie stuff
function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + (exdays*24*60*60*1000));
  var expires = "expires="+ d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
