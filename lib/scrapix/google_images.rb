module Scrapix
  # download images from a Google Image Search
  class GoogleImages
    include Capybara::DSL

    # options can be:
    #   size: named size, e.g. icon, small, medium, large, 13mp, 1280x800, etc.
    #   safe: true or false
    #
    def initialize(query = nil, options = {})
      self.options = options
      self.query   = query
      self.total   = 100
    end

    def search_url(page_no = 1)
      "http://google.com/search?tbm=isch&q=#{@query}#{@params}&start=#{(page_no - 1)*20}"
    end

    def query=(q)
      @query = URI.escape(q) if q
    end

    def total=(n)
      @num = n.to_i
    end

    def options=(opts)
      # convert symbolic keys to string keys
      options = {}
      opts.each { |k,v| options[k.to_s] = v }

      # merge the options with defaults!
      @options ||= { "safe" => true, "size" => "any" }
      @options.merge!(options)
      sanitize_size

      # parametrize for url purposes
      @params = create_params
    end

    # params: page_no => starting page number for google results
    def find(page_no = 1)
      images = {}
      return images unless @query

      while images.count < @num
        visit search_url(page_no)
        links = Capybara.page.all("a")
        links = links.select{|x| x["href"] =~ /^\/imgres/} if links.any?
        return images unless links.any?
        page_counter = 0
        links.each do |link|
          attribs = CGI.parse(URI.parse(link["href"]).query) rescue nil
          next if attribs.nil?
          hash = Digest::MD5.hexdigest(attribs["imgurl"][0])
          unless images.has_key?(hash)
            images[hash] = {
              width:          attribs["w"][0],
              height:         attribs["h"][0],
              url:            attribs["imgurl"][0],
              reference_url:  attribs["imgrefurl"][0]
            }
            page_counter += 1
          end
        end
        page_no += 1
        break if page_counter == 0
      end
      images.take(@num).map{|x| x[1]}
    end

    private

    def validate_mp_size(mp)
      mp = mp.to_i
      lower_bound = 0; upper_bound = 9999;
      valid_mp_sizes = [ 2, 4, 6, 8, 10, 12, 15, 20, 40, 70 ]
      valid_mp_sizes.each do |s|
        return s if s == mp
        lower_bound = s if s < mp
        upper_bound = s if s > mp && s < upper_bound
      end
      mp - lower_bound > upper_bound - mp ? upper_bound : lower_bound
    end

    # if width or height is specified, use them as 'exact' size
    # otherwise, use a MP size for finding images larger than that size
    # otherwise, use a given named size
    def sanitize_size
      @options["size"] = case
                         when m = @options["size"].match(/^(\d*)x(\d*)$/)
                           then "isz:ex,iszw:#{m[1]},iszh:#{m[2]}"
                         when m = @options["size"].match(/^(\d*)$/)
                           then "isz:ex,iszw:#{m[1]},iszh:#{m[1]}"
                         when m = @options["size"].match(/^(\d*)mp$/)
                           then "isz:lt,islt:#{validate_mp_size(m[1])}mp"
                         when @options["size"] == "large" then "isz:l"
                         when @options["size"] == "medium" then "isz:m"
                         when @options["size"] == "small" then "isz:s"
                         when @options["size"] == "icon" then "isz:i"
                         else nil
                         end
    end

    def create_params
      string  = ""
      string += "&tbs=#{@options["size"]}" if @options["size"]
      string += "&safe=off" unless @options["safe"]
      string
    end
  end
end
