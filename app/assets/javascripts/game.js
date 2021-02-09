function initGame() {
  bindImageFunction($(".hand img"), resizeGame);
  bindImageFunction($(".meme img"), makeTemplateMeme);
  bindImageFunction($(".template img"), makeTemplateMeme);

  $(".hand-img").off();
  $(".hand-img").click(selectSource);

  $(".meme").off();
  $(".meme").click(clickMeme);

  resizeGame();
  scrollMessages();
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
    // TODO: store dimensions as a percentage of template in db
    //       instead of calculating it here
    ratio = 200 / $("img.base").prop("naturalHeight");
    $(this).css("top",    ratio * parseInt($(this).attr("data-y")));
    $(this).css("left",   ratio * parseInt($(this).attr("data-x")));
    $(this).css("height", ratio * parseInt($(this).attr("data-height")));
    $(this).css("width",  ratio * parseInt($(this).attr("data-width")));
  });
}

function scrollMessages() {
  var el = $(".messages")[0];
  el.scrollTop = el.scrollHeight;
}

function resizeGame() {
  // Subtract 10px for padding
  var scaleHand = (window.innerWidth - 10) / $(".hand-resize").width();
  $(".hand-resize").css({transform: "scale("+scaleHand+")"});

  $(".bottom").height($(".hand-resize").height() * scaleHand - 10);

  // Subtract 60px for padding (20px) + head (40px)
  var mainHeight = window.innerHeight - $(".bottom").height() - 60;
  $(".main").height(mainHeight);
  $(".sidebar").height(mainHeight);
  $(".messages").height(mainHeight - $(".scoreboard").outerHeight() - 90);

  var heightRatio = $(".main").height() / $("#main").outerHeight();
  var widthRatio = $(".main").width() / $("#main").outerWidth();
  var scale = Math.min(heightRatio, widthRatio);
  var midpoint = ($(".main").width() - $("#main").outerWidth()*scale) / 2
  $("#main").css({transform: "scale("+scale+")", left: midpoint});
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

function playHand() {
  $(".hand-container").addClass("noclick");
  $("#playHand").prop("disabled", true);
  App.player.play_sources([
    parseInt($(".source1 img").data("source-id")),
    parseInt($(".source2 img").data("source-id")),
    parseInt($(".source3 img").data("source-id"))
  ]);
}

function clickMeme() {
  $(".meme").removeClass("selected");
  $(this).addClass("selected");
}

function selectMeme() {
  var meme = parseInt($(".meme.selected").data("meme-id"));
  App.player.select_meme(meme);
  $("#selectMeme").prop("disabled", true);
}

function sendMessage(event) {
  if(event.keyCode == 13 && event.target.value != "") {
    App.player.message(event.target.value);
    event.target.value = "";
  }
}

$(window).on("resize", resizeGame);

$(document).on("turbolinks:load", function() {
  initGame();
  $("#chatbox").keypress(sendMessage);
})
