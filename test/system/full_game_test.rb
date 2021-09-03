require 'application_system_test_case'

class PlayerSession < ApplicationSystemTestCase
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def as(player)
    if player == "Alice"
      yield
    else
      Capybara.using_session(player) { yield }
    end
  end

  def create_game
    as(name) do
      visit root_path
      fill_in "name", with: name
      click_on "Create game"
      find("#game")
      fill_in "max_score", with: 3
    end
  end

  def join
    path = current_url
    as(name) do
      visit path
      fill_in "name", with: name
      click_on "Join"
      find("#game")
    end
  end

  def play_hand
    as(name) do
      find(".placeholder", match: :first)
      find(".hand-img", match: :first)
      all(".placeholder").count.times do |i|
        all(".hand-img")[i].click
      end
      click_on "Play Hand"
    end
  end

  def select_meme
    as(name) do
      find(".meme", match: :first).click
      click_on "Select Meme"
    end
  end
end

class FullGameTest < ApplicationSystemTestCase
  test "full game" do
    players = [
      PlayerSession.new("Alice"),
      PlayerSession.new("Bob"),
      PlayerSession.new("Jen")
    ]

    master = players.first
    master.create_game
    players.excluding(master).each(&:join)

    click_on "Start"
    
    find("#main")
    round = 0
    
    until has_css?("#options") do
      czar = players[round % players.count]
      players.excluding(czar).each(&:play_hand)
      
      czar.select_meme
      sleep 3
      
      round += 1
    end
  end
end