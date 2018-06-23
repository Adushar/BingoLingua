document.addEventListener("turbolinks:load", function() {
  if (gon.cards.length >= gon.numer_of_tasks) {
    var random_cards = getRandom( gon.cards, gon.numer_of_tasks )
  }
  $( function() {
    $( ".connectedSortable" ).sortable({
      connectWith: ".connectedSortable",
      receive: function(event, ui) {
        // so if > 1
        if ($(this).children().length > 1) {
          //ui.sender: will cancel the change.
          //Useful in the 'receive' callback.
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
        cancelRequired = ($(this).children().length > 1);
      },
      stop: function() {
        if (cancelRequired) {
            $(this).sortable('cancel');
        }
      }
    }).disableSelection();
  });
});

function getRandom(arr, n) {
    var result = new Array(n),
        len = arr.length,
        taken = new Array(len);
    if (n > len)
        throw new RangeError("getRandom: more elements taken than available");
    while (n--) {
        var x = Math.floor(Math.random() * len);
        result[n] = arr[x in taken ? taken[x] : x];
        taken[x] = --len in taken ? taken[len] : len;
    }
    return result;
}
