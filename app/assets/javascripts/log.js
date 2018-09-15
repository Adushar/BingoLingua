var arr_of_log = []
window.onerror = function(msg, url, line) {
  console.log(msg);
  return false;
}
window.console.log = function(msg, url, line) {
  arr_of_log.push(msg);
}

$(document).on("turbolinks:load",function(){
  // START of js bug reportment
  $( "#bug" ).click(function() {
    if (arr_of_log.length) {
      $.ajax({
        url: '/js_log/',
        method: 'POST',
        data: {log: arr_of_log},
        success: function(response, status) {
          alert("Thank you for helping our site become better!");
        }
      });
    }
  });
  // END
})
