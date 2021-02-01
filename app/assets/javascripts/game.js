function initGame() {
  bindImageFunction($(".hand img"), resizeGame);
  bindImageFunction($(".meme img"), makeTemplateMeme);
  bindImageFunction($(".template img"), makeTemplateMeme);

  $(".hand-img").click(selectSource);
  $(".meme").click(selectMeme);
  $("#chatbox").keypress(sendMessage);
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

function resizeGame() {
  // Subtract 10px for padding
  var scaleHand = (window.innerWidth - 10) / $(".hand-resize").width();
  $(".hand-resize").css({transform: "scale("+scaleHand+")"});

  $(".bottom").height($(".hand-resize").height() * scaleHand - 20);

  // Subtract 30px for padding
  $(".main").height(window.innerHeight - $(".bottom").height() - 30);

  var templateHeightRatio = $(".main").height() / $("#template").height();
  var templateWidthRatio = $(".main").width() / $("#template").width();
  var scaleTemplate = Math.min(templateHeightRatio, templateWidthRatio);
  $("#template").css({transform: "scale("+scaleTemplate+")"});

  var memeHeightRatio = $(".main").height() / $("#memes").height();
  var memeWidthRatio = $(".main").width() / $("#memes").width();
  var scaleMeme = Math.min(memeHeightRatio, memeWidthRatio);
  $("#memes").css({transform: "scale("+scaleMeme+")"});
}

function playHand() {
  App.player.play_sources($(".hand img.selected").map(function() {
    return parseInt($(this).data("source-id"));
  }).get());
}

function selectSource() {
  var sources = $("[class^='hand-img source']").length;
  if($(this).is("[class^='hand-img source']")) {
    $(this).removeClass("source" + sources);
  } else if(sources < 3) {
    $(this).addClass("source" + (sources + 1));
  }
}

function selectMeme() {
  var meme = parseInt($(this).data("meme-id"));
  App.player.select_meme(meme);
}

function sendMessage(event) {
  if(event.keyCode == 13) {
    App.player.message(event.target.value);
    event.target.value = "";
    event.preventDefault();
  }
}

$(window).on("resize", resizeGame);

$(() => { initGame(); });
