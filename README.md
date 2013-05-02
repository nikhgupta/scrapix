# Pixlr

A gem that is able to search for keywords on Google Images and use Capybara
and Poltergeist driver to scrape those images. The gem can download these
images to a specified location, as well as can provide you with the results of
these searches.

## Installation

Add this line to your application's Gemfile:

    gem 'pixlr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pixlr

## Usage

To use the Google Images Scraper inside your ruby applications, simply do:

    scraper = Pixlr::GoogleImages.new # create the scraper
  
    scraper.query = "programmer"      # find images for keyword: "programmer"
    scraper.total = 30                # search is limited to 30 images (default: 100)
    scraper.find                      # return a list of such images

    # search for 'large' images, and put safesearch to off!
    scraper.options = { safe: false, size: "large" }
    scraper.find
  
    # everything:
    scraper = Pixlr::GoogleImages.new "programmer", safe: false, size: "large"
    scraper.total = 30 # limits to 30 images - default: 100 images
    scraper.find
  
  
The `size` option can be supplied in following ways:

  - __icon__, __small__, __medium__, or __large__
  - __&lt;n&gt;__: searches for images with exact dimensions (width: _&lt;m&gt;_, height: _&lt;n&gt;_)
  - __&lt;m&gt;x&lt;n&gt;__: searches for images with exact dimensions (width: _&lt;m&gt;_, height: _&lt;n&gt;_)
  - __&lt;n&gt;mp__: searches for images larger than _&lt;n&gt;_ MP. Intelligently, adjusts to
  the closest available option, if _&lt;n&gt;_ is not in the supported list of sizes
  for this search.
  
You can also use the scraper on CLI:

    pixlr google_images "programmer" --no-safe --total=30 --size=large

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
