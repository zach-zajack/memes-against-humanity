module ShitpostData
  extend ActiveSupport::Concern

  included do |base|
    base.const_set(:DATA, JSON.parse(File.open("public/data.json").read))
    base.const_set(:DOMAIN, "https://www.shitpostbot.com")
  end
end
