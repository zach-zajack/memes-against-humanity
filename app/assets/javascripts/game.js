function initGame() {
  initHand();
  initTemplate();
}

function initTemplate() {
  $(".template img").off();

  $(".template img").on("load", function() {
    $(".placeholder").map(function() {
      $(this).css("top",    $(this).attr("data-y") + "px");
      $(this).css("left",   $(this).attr("data-x") + "px");
      $(this).css("height", $(this).attr("data-height") + "px");
      $(this).css("width",  $(this).attr("data-width") + "px");
    });
  }).each(function() {
    if(this.complete) $(this).trigger("load");
  });
}

function initHand() {
  $(".hand img").off();

  $(".hand img").on("load", function() {
    resizeHand();
  }).each(function() {
    if(this.complete) $(this).trigger("load");
  });

  $(".hand img").click(function() {
    if($(this).hasClass("selected")) {
      $(this).removeClass("selected");
    } else {
      $(this).addClass("selected");
    }
  });
}

function resizeHand() {
  var scale = $(".bottom").width() / $(".hand").width();
  $(".hand").css({transform: "scale("+scale+")"});
}

function playHand() {
  App.game.play_sources($(".hand img.selected").map(function() {
    return parseInt($(this).attr("data-sourceid"));
  }).get());
}

$(window).on("resize", resizeHand);

$(() => { initGame(); });
