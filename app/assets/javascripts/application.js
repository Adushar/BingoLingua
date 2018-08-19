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
//= require turbolinks
//= require_tree .
//= require popper

var playlist = function(audio_arr, onPlay, data, endFunc, e) {
  // initialisation:
    pCount = 0;
    playlistUrls = audio_arr, // audio list
    howlerBank = [],
    volume = 1,
    loop = false;

  // playing i+1 audio (= chaining audio files)
  var onEnd = function(e) {
    setTimeout(function(){
      if (loop === true ) { pCount = (pCount + 1 !== howlerBank.length)? pCount + 1 : 0; }
      else { pCount = pCount + 1; }
      if (howlerBank[pCount]) {howlerBank[pCount].play()};
      if (endFunc) {endFunc();}
      if (audio_arr.length == pCount) {
        SearchForSortable();
      }
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
  if (typeof howlerBank !== 'undefined') {
    howlerBank.forEach(function(obj) {
      obj.stop();
    });
  }
}

function playSound(soundfile) {
  $("#delete_me").remove();
  setTimeout(function(){
    $('body').append('<audio id="delete_me" src="' + soundfile + '" autostart="false" preload="none" ></audio>');
    $("#delete_me")[0].play();
  }, 150);
};

// IMPORTANT functions for test blocks
function GenerateTest(cards, random_cards) {
  var obj = ".container.test_part"
  var row = $('<div />').attr('class','row');
  var empty_row = $('<div />').attr('class','row');
  var check_row = $('<div />').attr('class','row example');
  var only_sound_array = cards.map(function(item){return item.sound;});
  console.log([cards, random_cards]);
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
  return $.ajax({
    url: '/check_answer/' + test_id,
    type: 'get',
    data: {
      user_answer: "[" + answer + "]"
    },
    success: function(data) {
      console.log(data);
      return GenerateAnswer(JSON.parse(data["cards"]), data["errors"]);
    },
    error: function(xhr) {
      return console.log("Ops, smth got wrong(");
    }
  });
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
    return $.ajax({
      url: '/cards_refresh/' + test_id,
      type: 'get',
      data: {
        test_part: test_part
      },
      success: function(data) {
        console.log(getCookie('level') === "4");
        if (JSON.parse(data["cards"]).length < 4 && getCookie('level') === "4") {
          return alert("Selected cards isn't enough. You need to choose " + (4 - JSON.parse(data["cards"]).length) + " more card(s)");
        } else {
          stopMusic();
          $(".slider-block").hide();
          $(".container.test_part").html();
          GenerateTest(JSON.parse(data["cards"]), JSON.parse(data["mixed_cards"]));
        }
      },
      error: function(xhr) {
        return console.log("Ops, smth got wrong(");
      }
    });
  };

function GenerateAnswer(cards, errors) {
  var only_sound_array = cards.map(function(item){return item[0];});
  console.log(only_sound_array);
  console.log([cards, errors]);
  stopMusic();
  playlist(
    only_sound_array,
    function(e) {
      var sound_url = cards[pCount][1]
      var current_li = '<li class="ui-state-default position-relative"><img src="'+sound_url+'"><p class="full-width text-capitalize">'+decodeURIComponent(sound_url.match(/([^\/]+)(?=\.\w+$)/)[0]);+'</p></li>';
      var answer_row = $('.row:nth-child(2) > .col > ul.target > li.ui-state-default').eq(pCount)
      var success_img = '<i class="fa fa-check img_over good" aria-hidden="true"></i>';
      var fail_img = '<i class="fa fa-times img_over bad" aria-hidden="true"></i>';
      // var card_description = '<h2 class="full-width">Its bow</h2>'

      $('.connectedSortable').sortable('disable');
      if (errors && errors[pCount] == false) {
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
          cards_refresh();
        }, 1000);
      }
    }
  );
}

function finish_test() {
  var test_id, url;
  url = window.location.pathname;
  test_id = url.substring(url.lastIndexOf('/') + 1);
  return $.ajax({
    url: '/finish_test/' + test_id,
    type: 'get',
    error: function(xhr) {
      return console.log("Ops, smth got wrong(");
    }
  });
};

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
