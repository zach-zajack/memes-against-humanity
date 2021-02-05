function initGame() {
  bindImageFunction($(".hand img"), resizeGame);
  bindImageFunction($(".meme img"), makeTemplateMeme);
  bindImageFunction($(".template img"), makeTemplateMeme);

  $(".hand-img").click(selectSource);
  $(".meme").click(selectMeme);

  resizeGame();
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

  $(".bottom").height($(".hand-resize").height() * scaleHand - 10);

  // Subtract 20px for padding
  var mainHeight = window.innerHeight - $(".bottom").height() - 20;
  $(".main").height(mainHeight);
  $(".sidebar").height(mainHeight);
  $(".messages").height(mainHeight - $(".scoreboard").outerHeight())

  var templateHeightRatio = $(".main").height() / $("#template").outerHeight();
  var templateWidthRatio = $(".main").width() / $("#template").outerWidth();
  var scaleTemplate = Math.min(templateHeightRatio, templateWidthRatio);
  $("#template").css({transform: "scale("+scaleTemplate+")"});

  var memeHeightRatio = $(".main").height() / $("#memes").outerHeight();
  var memeWidthRatio = $(".main").width() / $("#memes").outerWidth();
  var scaleMeme = Math.min(memeHeightRatio, memeWidthRatio);
  $("#memes").css({transform: "scale("+scaleMeme+")"});
}

function playHand() {
  $(".hand-container").addClass("noclick");
  App.player.play_sources([
    parseInt($(".source1 img").data("source-id")),
    parseInt($(".source2 img").data("source-id")),
    parseInt($(".source3 img").data("source-id"))
  ]);
  $(this).preventDefault();
}

function selectSource() {
  var slots = $(".placeholder").length
  var sources = $("[class^='hand-img source']").length;
  if($(this).is("[class^='hand-img source']")) {
    $(this).removeClass("source" + sources);
    sources--;
  } else if(sources < slots) {
    $(this).addClass("source" + (sources + 1));
    sources++;
  }
  $("#playHand").prop("disabled", sources != slots);
}

function selectMeme() {
  var meme = parseInt($(this).data("meme-id"));
  App.player.select_meme(meme);
  $(this).preventDefault();
}

function sendMessage(event) {
  if(event.keyCode == 13 && event.target.value != "") {
    App.player.message(event.target.value);
    event.target.value = "";
    event.preventDefault();
  }
}

$(window).on("resize", resizeGame);

$(document).on("turbolinks:load", function() {
  initGame();
  $("#chatbox").keypress(sendMessage);
})
