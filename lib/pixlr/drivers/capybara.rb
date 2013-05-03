# capybara for scraping
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new app, {
    timeout:            600,
    inspector:          true,
    # js_errors:          false,
    phantomjs_options:  ["--web-security=no"]
  }
end

# use javascript driver
Capybara.current_driver = :poltergeist_debug

Pixlr::UserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) " +
                   "AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31"

