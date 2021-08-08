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

function isMobile() {
  return window.innerHeight > window.innerWidth;
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
    ratio = 400 / $("img.base").prop("naturalHeight");
    $(this).css("top",    ratio * parseInt($(this).attr("data-y")));
    $(this).css("left",   ratio * parseInt($(this).attr("data-x")));
    $(this).css("height", ratio * parseInt($(this).attr("data-height")));
    $(this).css("width",  ratio * parseInt($(this).attr("data-width")));
  });
}

function scrollMessages() {
  var el = $(".messages")[0];
  el.scrollTop = el.scrollHeight - el.clientHeight;
}

function resizeGame() {
  var handWidth = $(".hand-resize").width() + $(".hand-resize2").width();
  var handScale = (window.innerWidth - 10) / handWidth;

  // TODO: really not a fan of this hacky DOM-manipulation garbage,
  //       but I can't think of a better solution right now
  if (handScale < 1) {
    if($(".hand-resize2").length == 0) {
      $(".hand-resize").after("<div class='hand-resize2'></div>");
    }
    
    var handWidthTotal = 0;
    $(".hand-resize").children().each(function() {
      if(handWidthTotal * 2.5 > handWidth) {
        $(".hand-resize2").append($(this));
      } else {
        handWidthTotal += $(this).width();
      }
      $(".hand-resize").css({ transform: "translateY(-82px)" });
    });
    handScale = (window.innerWidth - 10) / Math.max(handWidthTotal, handWidth - handWidthTotal);
    handScale = Math.max(handScale, 1);
    $(".bottom").height($(".hand-resize").height() * handScale * 2 - 10);
    $(".hand-resize").css({ transform: "scale(" + handScale + ") translateY(-82px)" });
    $(".hand-resize2").css({ transform: "translateY(-82px) scale(" + handScale + ")" });
  } else {
    if($(".hand-resize2").length == 1) {
      $(".hand-resize2").children().each(function (i) { $(".hand-resize").append($(this)); });
      $(".hand-resize2").remove();
    }
    $(".bottom").height($(".hand-resize").height() * handScale - 10);
    $(".hand-resize").css({ transform: "scale(" + handScale + ")" });
  }
  
  // Subtract 60px for padding (20px) + head (40px)
  var mainHeight = window.innerHeight - $(".bottom").height() - 60;

  $(".main").height(mainHeight);
  $(".buttons").css({ top: mainHeight });

  if(isMobile()) {
    $(".main").css({ top: $(".scoreboard").outerHeight() + 40 });
    $(".sidebar").height($(".scoreboard").outerHeight());
  } else {
    $(".main").css({ top: 40 });
    $(".sidebar").height(mainHeight);
    $(".messages").height(mainHeight - $(".scoreboard").outerHeight() - 90);
  }

  var heightRatio = $(".main").height() / $("#main").outerHeight();
  var widthRatio = $(".main").width() / $("#main").outerWidth();
  var scale = Math.min(heightRatio, widthRatio);
  var midpoint = ($(".main").width() - $("#main").outerWidth() * scale) / 2
  $("#main").css({ transform: "scale(" + scale + ")", left: midpoint });
}

function selectSource() {
  var slots = $(".placeholder").length;
  var source_sel = "[class^='hand-img source']";
  var sources = $(source_sel).length;
  var classname = "source" + sources;

  if(slots == 1 && sources == 1) {
    $(".source1").removeClass("source1");
    $(this).addClass("source1");
    return;
  }

  if($(this).is(source_sel) && $(this).hasClass(classname)) {
    $(this).removeClass(classname);
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
    event.preventDefault();
  }
}

function selectWinner(winner) {
  var meme   = $("[data-meme-id='"   + winner.meme_id + "']");
  var player = $("[data-player-id='" + winner.id + "']");
  var score  = $("[data-player-id='" + winner.id + "'] .score");
  meme.addClass("winner");
  player.addClass("winner active");
  score.html(parseInt(score.html()) + 1);
}

$(window).on("resize", resizeGame);

$(document).on("turbolinks:load", function() {
  if($("#game").length == 0) return;
  initGame();
  $("#chatbox").keypress(sendMessage);
});