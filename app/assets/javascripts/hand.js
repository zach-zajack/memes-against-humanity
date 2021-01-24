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

$(() => {
  resizeHand();

  $(".hand img").click(function() {
    if($(this).hasClass("selected")) {
      $(this).removeClass("selected");
    } else {
      $(this).addClass("selected");
    }
  });
});
