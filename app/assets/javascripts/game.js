function initGame() {
  initHand();
  initMeme();
}

function initMeme() {
  $(".meme img").off();

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
  var scaleHand = ($(this).width() - 10) / $(".hand-resize").width();
  $(".hand-resize").css({transform: "scale("+scaleHand+")"});

  // Add 20px for the button
  var bottomHeight = $(".hand-resize").height() * scaleHand + 20;
  $(".bottom").height(bottomHeight);

  var mainHeight = $(this).height() - bottomHeight;
  $(".main").height($(this).height() - bottomHeight);

  var templateHeightRatio = (mainHeight - 30) / $("#template").height();
  var templateWidthRatio = $(".main").width() / $("#template").width();
  var scaleTemplate = Math.min(templateHeightRatio, templateWidthRatio);
  $("#template").css({transform: "scale("+scaleTemplate+")"});

  var memeHeightRatio = (mainHeight - 30) / $("#memes").height();
  var memeWidthRatio = $(".main").width() / $("#memes").width();
  var scaleMeme = Math.min(memeHeightRatio, memeWidthRatio);
  $("#memes").css({transform: "scale("+scaleMeme+")"});
}

function playHand() {
  App.player.play_sources($(".hand img.selected").map(function() {
    return parseInt($(this).attr("data-sourceid"));
  }).get());
}

$(window).on("resize", resizeGame);

$(() => { initGame(); });
