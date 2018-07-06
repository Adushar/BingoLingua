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

var playlist = function(audio_arr, onPlay, data, e) {
  // initialisation:
    pCount = 0;
    playlistUrls = audio_arr, // audio list
    howlerBank = [],
    loop = false;

  // playing i+1 audio (= chaining audio files)
  var onEnd = function(e) {
    if (loop === true ) { pCount = (pCount + 1 !== howlerBank.length)? pCount + 1 : 0; }
    else { pCount = pCount + 1; }
    if (howlerBank[pCount]) {howlerBank[pCount].play()};
  };

  // build up howlerBank:
  playlistUrls.forEach(function(current, i) {
    howlerBank.push(new Howl({ urls: [playlistUrls[i]], onend: onEnd, onplay: onPlay, buffer: true }))
  });

  // initiate the whole :
  howlerBank[0].play();
}

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
  playlist(
    only_sound_array,
    function(e) {$('.container.test_part > .row:nth-child(2) > .col-2:nth-child('+(pCount+1)+') .target').addClass("temp_black");
  });
  $.each( random_cards, function( index, value ) {
    var current_ul_li = `<div class="col-2"><ul class="connectedSortable"><li class="ui-state-default"  data-id="`+value.id+`"><img src="${value.picture}"></li></ul></div>`;
    var empty_ul_li = `<div class="col-2"><ul class="connectedSortable target"></ul></div>`
    var example_ul_li = `<div class="col-2"><ul class="exampleSortable target"></ul></div>`
    $(row).append(current_ul_li);
    $(empty_row).append(empty_ul_li);
    $(check_row).append(example_ul_li);
  });
  $(obj).html(row);
  $(obj).append(empty_row);
  $(obj).append(check_row);
}

function GenerateAnswer(cards, errors) {
  var only_sound_array = cards.map(function(item){return item[0];});
  console.log(only_sound_array);
  console.log([cards, errors]);
  stopMusic();
  playlist(
    only_sound_array,
    function(e) {
      var current_li = `<li class="ui-state-default"><img src="${cards[pCount][1]}"></li>`;
      var answer_row = $('.row:nth-child(2) > .col-2 > ul.target > li.ui-state-default').eq(pCount)
      var success_img = `<i class="fa fa-check img_over good" aria-hidden="true"></i>`;
      var fail_img = `<i class="fa fa-times img_over bad" aria-hidden="true"></i>`;
      if (errors && errors[pCount] == false) {
        answer_row.append(fail_img);
        console.log(errors[pCount]);
      } else {
        answer_row.append(success_img);
        console.log(true);
      }
      $('.row.example > .col-2 > ul.target').eq(pCount).html(current_li);
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
