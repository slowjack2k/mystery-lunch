RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      if ENV["SHOW_BROWSER"] == "true"
        driven_by :selenium_chrome do |option|
          # within docker chrome runs as root for now
          option.add_argument("no-sandbox")
          option.add_argument("disable-gpu")
        end
      else
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |option|
          option.add_argument("no-sandbox")
          option.add_argument("disable-gpu")
        end
      end
    else
      # for none js rack is faster and enough
      driven_by(:rack_test)
    end
  end
end
