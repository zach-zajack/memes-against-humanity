function initGame() {
  bindImageFunction($(".hand img"), resizeGame);
  bindImageFunction($(".meme img"), makeTemplateMeme);
  bindImageFunction($(".template img"), makeTemplateMeme);

  $(".hand img").click(makeSelectable);
}

function bindImageFunction(el, fun) {
  el.off();
  el.on("load", fun).each(function() {
    if(this.complete) $(this).trigger("load");
  });
}

function makeTemplateMeme() {
  resizeGame();
  $(".placeholder").map(function() {
    $(this).css("top",    $(this).attr("data-y") + "px");
    $(this).css("left",   $(this).attr("data-x") + "px");
    $(this).css("height", $(this).attr("data-height") + "px");
    $(this).css("width",  $(this).attr("data-width") + "px");
  });
}

function makeSelectable() {
  if($(this).hasClass("selected")) {
    $(this).removeClass("selected");
  } else {
    $(this).addClass("selected");
  }
}

function resizeGame() {
  var scaleHand = (window.innerWidth - 10) / $(".hand-resize").width();
  $(".hand-resize").css({transform: "scale("+scaleHand+")"});

  // Add 20px for the button
  var bottomHeight = $(".hand-resize").height() * scaleHand + 20;
  $(".bottom").height(bottomHeight);

  var mainHeight = window.innerHeight - bottomHeight;
  $(".main").height(window.innerHeight - bottomHeight);

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
