module Scrapix
  # download images from a vBulletin thread
  class VBulletin

    attr_reader :title, :max_pages, :options, :page_no, :images, :url

    def initialize(url = nil, options = {})
      @images                 = {}
      @agent                  = Mechanize.new
      @agent.user_agent_alias = 'Mac Safari'
      self.options            = options
      self.url                = url
    end

    # find images for this thread, specified by starting page_no
    def find
      reset; return @images unless @url
      @page_no = @options["start"]
      until @images.count > @options["total"] || thread_has_ended?
        page      = @agent.get "#{@url}&page=#{@page_no}"
        puts "[VERBOSE] Searching: #{@url}&page=#{@page_no}" if @options["verbose"] && options["cli"]
        sources   = page.image_urls.map{|x| x.to_s}
        sources   = filter_images sources # hook for sub-classes
        @page_no += 1
        continue if sources.empty?
        sources.each do |source|
          hash = Digest::MD5.hexdigest(source)
          unless @images.has_key?(hash)
            @images[hash] = {url: source}
            puts source if options["cli"]
          end
        end
      end
      @images = @images.map{|x, y| y}
    end

    def thread_has_ended?
      @page_no > @options["end"] || @page_no > @max_pages
    end

    def filter_images(sources)
      # useful for filtering the image by sub-classes
      return sources
    end

    def url=(url)
      @url = url
      return unless @url
      page = @agent.get @url
      @title = page.title.strip
      puts @title + "\n" + ("=" * @title.length) if self.options["cli"]
      begin
        text = page.search(".pagenav .vbmenu_control").first.inner_text
        @max_pages = text.match(/Page \d* of (\d*)/)[1].to_i
      rescue
        @max_pages = 1
      end
    end

    def reset
      @images  = {}
      @page_no = @options["start"]
    end

    def options=(options = {})
      @options = { "start" => 1, "end" => 10000, "total" => 100000, "verbose" => false, "cli" => false }
      options.each { |k,v| @options[k.to_s] = v }
      ["start", "end", "total"].each {|k| @options[k] = @options[k].to_i}
      @options
    end
  end
end
