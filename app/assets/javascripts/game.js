function initGame() {
  initHand();
  initMeme();
}

function initMeme() {
  $(".meme img").off();

  $(".template img").on("load", function() {
  $(".meme img").on("load", function() {
    resizeGame();
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
    resizeGame();
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

function resizeGame() {
  var scaleHand = $(this).width() / $(".hand-resize").width();
  $(".hand-resize").css({transform: "scale("+scaleHand+") translateY(-"+scaleHand+"%)"});
  var bottomHeight = $(".hand-resize").height() * scaleHand + 20;
  $(".bottom").height(bottomHeight);

  var mainHeight = $(this).height() - bottomHeight;
  $(".main").height($(this).height() - bottomHeight);
  var scaleTemplate = (mainHeight - 30) / $(".template img").height();
  $(".template").css({transform: "scale("+scaleTemplate+")"});
  $(".meme").css({transform: "scale("+scaleTemplate+")"}); // TODO: replace
}

function playHand() {
  App.player.play_sources($(".hand img.selected").map(function() {
    return parseInt($(this).attr("data-sourceid"));
  }).get());
}

$(window).on("resize", resizeGame);

$(() => { initGame(); });
