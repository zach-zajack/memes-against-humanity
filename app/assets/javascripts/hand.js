function resizeHand() {
  var scale = $(".bottom").width() / $(".hand").width();
  $(".hand").css({transform: "scale("+scale+")"});
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
