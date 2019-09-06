# *************** IMPORTS **********************
require 'pry'
require 'watir'
require 'nokogiri'
require 'nokogiri-styles'
require 'rtesseract'
require 'rmagick'
require 'open-uri'
require "mini_magick"
require 'rest-client'
require 'watir/extensions/element/screenshot'

# Load ENV variables in this file in development
unless Rails.env.production?
  environment_variables = File.join(Rails.root, 'config', 'initializers', 'environment_variables.rb')
  load(environment_variables) if File.exists?(environment_variables)
end

desc "Scrapes immoweb, zimmo and immoscoop for new listings"
task :scrape do
  class String
    def normalize
      self.gsub(/[áàâä]/i, 'a').gsub(/[úùûü]/i, 'u').gsub(/[éèêë]/i, 'e').gsub(/[óòôö]/i, 'o').gsub(/[ïîìí]/i, 'i')
    end
  end

  # *************** CLASS **********************
  class HouseHunter 
    def initialize
      @scrapes = ["scrape_immoscoop_houses","scrape_immoscoop_appartments","scrape_zimmo","scrape_immoweb_houses", "scrape_immoweb_appartments","scrape_immovlan"]
      # realo, propenda
      @scrape_index = -1
      @client_id = ENV["CLIENT_ID"]
      @client_secret = ENV["CLIENT_SECRET"]
      @refresh_token = ENV["REFRESH_TOKEN"]
      @access_token = nil
      @sheet_id = ENV["SHEET_ID"]
      @sheet_name = ENV["SHEET_NAME"]
      @api_key = ENV["API_KEY"]
      @max_tries = 10
      options = Selenium::WebDriver::Chrome::Options.new
      chrome_bin_path = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
      puts "$#{ENV}"
      puts "$#{chrome_bin_path}"
      options.binary = chrome_bin_path if chrome_bin_path # only use custom path on heroku
      # options.add_argument('--headless') # this may be optional
      @browser = Watir::Browser.new :chrome, options: options
      @data = []  
      @current = []
      @max_price = 400000

    end

    def next_scrape
      @scrape_index += 1
      (puts "scrapes ended, shutting down"; abort;) if @scrape_index >= @scrapes.length
      puts "Starting scrape on #{@scrapes[@scrape_index].gsub('scrape_','')}"
      self.send(@scrapes[@scrape_index])
    end

    # ======================================================
    # HELPER FUNCTIONS
    # ======================================================
    def is_numeric?(obj) 
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def refresh_token
      payload = {
        client_id: @client_id,
        client_secret: @client_secret,
        refresh_token: @refresh_token,
        grant_type: "refresh_token"
      }
    
      res = JSON.parse(RestClient.post("https://accounts.google.com/o/oauth2/token", payload))
      @access_token = res["access_token"]
    end

    def get_current
      current = JSON.parse(RestClient.get("https://sheets.googleapis.com/v4/spreadsheets/#{@sheet_id}/values/#{@sheet_name}?valueRenderOption=FORMATTED_VALUE&access_token=#{@access_token}&key=#{@api_key}"))['values'] || []
      current.shift
      @current = current.map{|i| i[0].downcase.split(" - ")[0]}
    end

    def save_progress
      @data.sort_by! {|i| -i[:status] } # sort by criteria 
      @data.uniq! {|i| i[:address] } # remove duplicates 
      @data.reject!{|i| i[:address].match(/\badres\b/)} # Remove everything that contains the word 'adres' ..op aanvraag, ..aan te vragen, ..
      puts "SAVING PROGRESS! DATA: #{@data}"
      puts "Found #{@data.size} new houses! adding to sheet!"
      add_to_sheet if @data.size > 0
      get_current 
      @data = []
    end

    def add_to_sheet
      payload = {
        values: @data.map{|i| i.values}
      }
      RestClient.post("https://sheets.googleapis.com/v4/spreadsheets/#{@sheet_id}/values/#{@sheet_name}!A1:K1:append?valueInputOption=RAW&access_token=#{@access_token}&key=#{@api_key}", payload.to_json, {content_type: :json, accept: :json})
    end

    def get_price
      begin 
        @browser.element(:xpath => "/html/body/section[1]/div/div/div[2]/div/div/div[2]/strong").screenshot("price.png")
        file = Tempfile.new(['image', 'price.png'],Rails.root.join('tmp'))
        file.binmode
        file.write open('price.png').read
        file.flush
        image = RTesseract.new(file)
        image.to_s.strip.gsub!(/[^0-9]/,"")
      rescue => error
        binding.pry
      end
    end

    def get_address
      begin
        @browser.element(:xpath => "/html/body/section[1]/div/div/div[2]/div/div/div[1]/header/h1/span").screenshot("address.png")
        file = Tempfile.new(['image', 'address.png'],Rails.root.join('tmp'))
        file.binmode
        file.write open('address.png').read
        file.flush
        image = RTesseract.new(file)
        image.to_s.strip
      rescue => error
        nil
      end
    end

    # ======================================================
    # Immoscoop
    # ======================================================
    def scrape_immoscoop_houses
      @root = "https://www.immoscoop.be"
      next_page = "/immo.php?min_price=0&max_price=#{@max_price}&proptype=Sale&radio-1=on&radio-2=on&ajax=&distance=&country=&streetname=&livingareacondition=&livingarea=&plotareacondition=&plotarea=&yearcondition=&year=&province=&country=&bedroom=3&feature=&searchcity=&region=&category=Woning&order=price&s_postcode%5B%5D=158&s_postcode%5B%5D=56&s_postcode%5B%5D=57&s_postcode%5B%5D=58&s_postcode%5B%5D=1521"
      while next_page != "#" do 
        puts "starting scrape for next page \n\n"
        @browser.goto @root + next_page
        sleep 3
        html = Nokogiri::HTML(@browser.html)
        next_page = html.css('.pagination li:last-child a').attr('href').text
        listings = html.css('.search-result-position')
        scrape_immoscoop_listings(listings)
      end
      save_progress if @data.size > 0
      next_scrape
    end

    def scrape_immoscoop_appartments
      @root = "https://www.immoscoop.be"
      next_page = "/immo.php?min_price=0&max_price=#{@max_price}&proptype=Sale&radio-1=on&radio-2=on&ajax=&distance=&country=&streetname=&livingareacondition=&livingarea=&plotareacondition=&plotarea=&yearcondition=&year=&province=&country=&bedroom=3&feature=&searchcity=&region=&category=Appartement&order=price&s_postcode%5B%5D=158&s_postcode%5B%5D=56&s_postcode%5B%5D=57&s_postcode%5B%5D=58&s_postcode%5B%5D=1521"
      while next_page != "#" do 
        puts "starting scrape for next page \n\n"
        @browser.goto @root + next_page
        sleep 3
        html = Nokogiri::HTML(@browser.html)
        next_page = html.css('.pagination li:last-child a').attr('href').text
        listings = html.css('.search-result-position')
        scrape_immoscoop_listings(listings)
      end
      save_progress if @data.size > 0
      next_scrape
    end

    def scrape_immoscoop_listings(listings)
      puts "scraping immoscoop listings"
      listings.each do |listing|
        begin
          score = 0
          # GENERAL
          link = listing.css('.search-result-img-wrapper').attr('href').text
          puts "checking #{link}"
          @browser.goto link
          address = get_address
          puts "address = #{address}"
          (puts "skipping, no valid address found"; next;) if address === nil

          street_matches = @current.find_all{|i| i.normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}.concat(@data.find_all{|i| i[:address].normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}) # Check if street name has already been scraped
          if street_matches.size > 0
            (puts "skipping, already scraped property"; next;) if street_matches.any? {|street| address[/\b\d{1,3}\b/] === street[/\b\d{1,3}\b/]} # Skip property if street & number matches
          end
          img = listing.xpath('div[1]/div/div/div/div[1]/a')[0].styles['background-image'].gsub(/[url(,)]/,"").gsub('begie','belgie').gsub('s3-e-west','s3-eu-west')
          # PRICE
          price = get_price
          puts "price = #{price}"
          (puts "skipping, no price or invalid format"; next;) if price == nil || !is_numeric?(price.gsub!(/[^0-9]/,""))
          price = price.ljust(6, "0") if !price.match('0') # Add zeroes until 6 numbers when the price doesnt contain zeroes (catches tesseract slips)
          score += 1 if Integer(price) < 250000 # bonus point if below 250K
          score += (1 * ((250000 - Integer(price))/20000)) if Integer(price) < 250000 # bonus point for every 20k under 250K
          # BEDS
          beds = listing.xpath("div[1]/div/div/div/div[2]/div/span[2]").text[/\d+/]
          score += 1 if beds && Integer(beds) >= 3 # bonus point if 3 or more beds
          score += (1 * (Integer(beds) - 3)) if beds && Integer(beds) >= 3 # bonus point for every bedroom over 3
          # SIZE
          size = listing.xpath("div[1]/div/div/div/div[2]/div/span[3]").text[/\d+/] 
          score += 1 if size && Integer(size) >= 200 # bonus point if more than 200m2
          score += 1 if size && Integer(price)/Integer(size) <= 1300 # bonus point for low m2/price ratio
          # BROKER
          arr = listing.xpath('div[1]/div/div/div/div[2]/div/span[last()]/a')
          if arr.size == 0
            html = Nokogiri::HTML(@browser.html)
            broker = html.xpath('/html/body/section[2]/div/div/div[2]/article/div[2]/a[last()]').attr('href').text
          else 
            broker = arr.attr('href').text
          end
        rescue => error
          (puts "\n #{error}")
          Rails.env.production? ? (puts "FATAL ERROR IN #{@scrapes[@scrape_index].upcase}, GOING TO NEXT"; next;) : (puts "ERROR OCCURED, GOING TO NEXT"; next)
        end
        # ADDING DATA
        puts "#{address}: BEDS: #{beds}, SIZE: #{size}, PRICE: #{price} => SCORE = #{score}"
        @data << {address: address,beds: beds, baths: '', size: size, price: price, info: '', status: score, broker: broker, link: link, img: img, coördinates: "", date: Time.now.to_s}
      end
    end

    # ======================================================
    # Zimmo
    # ======================================================
    def scrape_zimmo
      @root = "https://www.zimmo.be"
      next_page = "/nl/panden/?status=1&type%5B0%5D=5&type%5B1%5D=4&type%5B2%5D=1&subType%5B0%5D=46&subType%5B1%5D=13&subType%5B2%5D=49&subType%5B3%5D=72&subType%5B4%5D=73&subType%5B5%5D=74&subType%5B6%5D=75&subType%5B7%5D=76&subType%5B8%5D=78&subType%5B9%5D=81&subType%5B10%5D=82&subType%5B11%5D=83&subType%5B12%5D=84&subType%5B13%5D=85&subType%5B14%5D=86&subType%5B15%5D=89&subType%5B16%5D=90&subType%5B17%5D=91&subType%5B18%5D=92&subType%5B19%5D=93&subType%5B20%5D=94&subType%5B21%5D=98&subType%5B22%5D=100&subType%5B23%5D=101&subType%5B24%5D=105&subType%5B25%5D=113&subType%5B26%5D=115&subType%5B27%5D=120&hash=805008986172b797be7c03e337cd95b8&priceMax=#{@max_price}&priceIncludeUnknown=1&priceChangedOnly=0&bedroomsMin=2&bedroomsIncludeUnknown=1&bathroomsIncludeUnknown=1&constructionType%5B0%5D=3&constructionIncludeUnknown=1&livingAreaIncludeUnknown=1&landAreaIncludeUnknown=1&commercialAreaIncludeUnknown=1&yearOfConstructionMin=1900&yearOfConstructionIncludeUnknown=1&epcIncludeUnknown=1&newConstructionOnly=0&projectsOnly=0&queryCondition=and&includeNoPhotos=1&includeNoAddress=1&onlyRecent=0&onlyRecentlyUpdated=0&isPlus=0&region=polygon&path=sluwHqrzYbuDnvDx%7C%40chBfdAaNzx%40vI%60mA%60%5D%60GolB~Bc%60EifAslC%7DmBrUos%40_k%40uwAoc%40sd%40hmAyv%40pV_h%40d%7C%40aEbt%40Snz%40jBhjB%3F~M#gallery"
      while next_page != "#" do 
        puts "starting scrape for next page \n\n"
        @browser.goto @root + next_page.gsub(@root,'')
        sleep 3
        html = Nokogiri::HTML(@browser.html)
        next_page = html.css('.pagination li.last a').attr('href').text
        listings = html.css('.property-item')
        scrape_zimmo_listings(listings)
      end
      save_progress if @data.size > 0
      next_scrape
    end

    def scrape_zimmo_listings(listings)
      listings.each do |listing|
        # GENERAL
        begin
          score = 0
          link = listing.css('.property-item_link').attr('href').text.strip
          address = listing.css('.property-item_address').text.gsub(/\s+/, " ").strip.downcase
          next if !address
          street_matches = @current.find_all{|i| i.normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}.concat(@data.find_all{|i| i[:address].normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}) # Check if street name has already been scraped
          if street_matches.size > 0
            (puts "skipping, already scraped property"; next;) if street_matches.any? {|street| address[/\b\d{1,3}\b/] === street[/\b\d{1,3}\b/]} # Skip property if street & number matches
          end
          @browser.goto @root + link
          puts "checking #{link}"
          html = Nokogiri::HTML(@browser.html)
          img = html.css('.flex-active-slide img').size > 0 ? html.css('.flex-active-slide img').attr('src').text : ""
          # PRICE
          price = listing.css('.property-item_price').text.strip.gsub!(/[^0-9]/,"")
          (puts "skipping, no price or invalid format"; next;) if price == nil || !is_numeric?(price)
          score += 1 if Integer(price) < 250000 # bonus point if below 250K
          score += (1 * ((250000 - Integer(price))/20000)) if Integer(price) < 250000 # bonus point for every 20k under 250K
          # BEDS & BATHS 
          beds = listing.css('span.bedroom-icon.property-item_icon').text.gsub(/\s+/, " ").strip.reverse[/\b\d{1,3}\b/]
          score += 1 if beds && Integer(beds) >= 3 # bonus point if 3 or more beds
          score += (1 * (Integer(beds) - 3)) if beds && Integer(beds) >= 3 # bonus point for every bedroom over 3
          baths = html.at('strong:contains("Badkamers")+span') ? html.at('strong:contains("Badkamers")+span').text.strip : nil
          # SIZE
          size = listing.css('span.opp-icon.property-item_icon').text[/\b\d{1,3}/]
          score += 1 if size && Integer(size) >= 200 # bonus point if more than 200m2
          score += 1 if size && Integer(price)/Integer(size) <= 1300 # bonus point for low m2/price ratio
          # BROKER
          broker =  html.css('.contact-logo img').size > 0 ? html.css('.contact-logo img').attr('alt').text : html.css('.phone-number-container').attr('data-mobile').text
        rescue => error
          (puts "\n #{error}")
          Rails.env.production? ? (puts "FATAL ERROR IN #{@scrapes[@scrape_index].upcase}, GOING TO NEXT"; next;) : (puts "ERROR OCCURED, GOING TO NEXT"; next)
        end
        # Adding Data
        puts "#{address}: BEDS: #{beds}, SIZE: #{size}, PRICE: #{price} => SCORE = #{score}"
        @data << {address: address,beds: beds, baths: baths, size: size, price: price, info: '', status: score, broker: broker, link: @root + link, img: img, coördinates: "", date: Time.now.to_s}
      end
    end

    # ======================================================
    # Immoweb
    # ======================================================
    def scrape_immoweb_houses
      @root = "https://www.immoweb.be"
      next_page = "/nl/zoek/huis/te-koop?zips=2000,2018,2020,2600,2610,2640&maxprice=#{@max_price}&minroom=2"
      while next_page != "#" do 
        puts "starting scrape for next page \n\n"
        @browser.goto @root + next_page.gsub(@root,'')
        html = Nokogiri::HTML(@browser.html)
        next_page = html.css('.navig-arrow-right a').size > 0 ? html.css('.navig-arrow-right a').attr('href').text : '#'
        listings = html.css('#result>div')
        scrape_immoweb_listings(listings)
      end
      save_progress if @data.size > 0
      next_scrape
    end

    def scrape_immoweb_appartments
      @root = "https://www.immoweb.be"
      next_page = "/nl/zoek/appartement/te-koop?zips=2000,2018,2020,2600,2610,2640&maxprice=#{@max_price}&minroom=2"
      while next_page != "#" do 
        puts "starting scrape for next page \n\n"
        @browser.goto @root + next_page.gsub(@root,'')
        html = Nokogiri::HTML(@browser.html)
        next_page = html.css('.navig-arrow-right a').size > 0 ? html.css('.navig-arrow-right a').attr('href').text : '#'
        listings = html.css('#result>div')
        scrape_immoweb_listings(listings)
      end
      save_progress if @data.size > 0
      next_scrape
    end 

    def scrape_immoweb_listings(listings)
      listings.each do |listing|
        # GENERAL
        score = 0
        link = listing.css('a')[0].attr('href').gsub(@root,"")
        @browser.goto @root + link.gsub(@root,'')
        puts "checking #{link}"
        sleep 1
        @tries = 0
        if !!Nokogiri::HTML(@browser.html).text.strip.match("Even geduld, aub...")
          puts 'Session limit reached, refreshing'
          @browser.execute_script("sessionStorage.clear(); localStorage.clear()")
          # Keep refreshing until page loads correctly or max retries is reached
          until (!Nokogiri::HTML(@browser.html).text.strip.match("Even geduld, aub...") || (@tries == @max_tries))
            # wait until something appears
            @tries += 1
            puts "refreshing, tries = #{@tries}"; 
            @browser.refresh; 
            sleep 5; 
          end 
        elsif Nokogiri::HTML(@browser.html).css("#newpropertypage .error-page").size > 0
          puts 'Error page reached, going to next';
          next;
        else
          puts "Waiting for page load"
          # Keep refreshing until page loads correctly or max retries is reached
          until (Nokogiri::HTML(@browser.html).css("#newpropertypage #image-one").size > 0 || (@tries == @max_tries))
            @tries += 1
            puts "refreshing, tries = #{@tries}"; 
            @browser.refresh; 
            sleep 5;
          end
        end
        (puts "max retries reached!"; next;) if @tries == @max_tries
        html = Nokogiri::HTML(@browser.html)
        puts "getting address"
        address = html.css('#propertyPage-title-address').text.gsub(/\s+/, " ").strip.downcase
        next if !address
        puts "checking matches"
        begin
          street_matches = @current.find_all{|i| i.normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}.concat(@data.find_all{|i| i[:address].normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}) # Check if street name has already been scraped
        rescue
          Rails.env.production? ? (puts "FATAL ERROR IN #{@scrapes[@scrape_index].upcase}, GOING TO NEXT"; next;) : (puts "ERROR OCCURED, GOING TO NEXT"; next)
        end
        if street_matches.size > 0
          puts "matches found, digging deeper"
          (puts "skipping, already scraped property"; next;) if street_matches.any? {|street| address[/\b\d{1,3}\b/] === street[/\b\d{1,3}\b/]} # Skip property if street & number matches
        end
        puts "getting image"

        begin
          img = html.css("#image-one.block a")[0].styles['background-image'].gsub(/[url(,),\s,'\\"']/,"")
          # PRICE
          puts "getting price"
          price = html.css('.iw-propertypage-price-current-content h3').text.gsub(/[€,.,' ',\s]/,"") 
          (puts "skipping, no price or invalid format"; next;) if price == nil || !is_numeric?(price.gsub(/[€,.,' ',\s]/,""))
          score += 1 if Integer(price) < 250000 # bonus point if below 250K
          score += (1 * ((250000 - Integer(price))/20000)) if Integer(price) < 250000 # bonus point for every 20k under 250
          # BEDS & BATHS
          puts "getting beds"
          beds = html.at('h3 span:contains("slaapkamers")+ span.blue') ? html.at('h3 span:contains("slaapkamers")+ span.blue').text : nil
          score += 1 if beds && Integer(beds) >= 3 # bonus point if 3 or more beds
          score += (1 * (Integer(beds) - 3)) if beds && Integer(beds) >= 3 # bonus point for every bedroom over 3
          puts "getting baths"
          baths = html.at('h3 span:contains("badkamer")+ span.blue') ? html.at('h3 span:contains("badkamer")+ span.blue').text : nil
          # SIZE
          puts "getting size"
          size = html.at('h3 span:contains("bewoonbare opp.")+ span.blue') ? html.at('h3 span:contains("bewoonbare opp.")+ span.blue').text[/\d+/] : nil
          score += 1 if size && Integer(size) >= 200 # bonus point if more than 200m2
          score += 1 if size && Integer(price)/Integer(size) <= 1300 # bonus point for m2/price < 1300
          # BROKER
          puts "getting broker || contact info"
          broker =  (html.css("#iw-propertypage-contactbox a.logo img").size > 0) ? (html.css("#iw-propertypage-contactbox a.logo img").attr('title').text.downcase) : (@browser.link(:text =>"Via telefoon contacteren").when_present.click)
          broker = html.css(".phones .phone").map{|i| i.text.strip.gsub(/[\D,\s]/,"")}.join(", +")
        rescue => error
           (puts "\n #{error}")
           Rails.env.production? ? (puts "FATAL ERROR IN #{@scrapes[@scrape_index].upcase}, GOING TO NEXT"; next;) : (puts "ERROR OCCURED, GOING TO NEXT"; next)
        end
        # Adding Data
        puts "#{address}: BEDS: #{beds}, SIZE: #{size}, PRICE: #{price} => SCORE = #{score}"
        @data << {address: address,beds: beds, baths: baths, size: size, price: price, info: '', status: score, broker: broker, link: @root + link, img: img, coördinates: "", date: Time.now.to_s}
      end
    end

    # ======================================================
    # Immovlan
    # ======================================================
    def scrape_immovlan
      @root = "https://immo.vlan.be/"
      next_page = "nl/Zoek/alle/alle/?city=(2000-Antwerpen)-(2018-Antwerpen)-(2020-Antwerpen)-(2600-Berchem)-(2610-Wilrijk)&country=Belgique&propertytype=(Opbrengstpand)-(Huis)-(Appartement)&propertysubtype=(Opbrengsteigendom)-(Huis)-(Villa)-(Bungalow)-(Chalet)-(Fermette)-(Herenhuis)-(Kasteel)-(Huis-gemengd-gebruik)-(Appartement)-(Gelijkvloers)-(Penthouse)-(Duplex)-(Triplex)-(Flat---Studio)-(Loft)&transactiontype=(te-koop)-(in-openbare-verkoop)&SortOrder=DefaultAscending&MaxPrice=#{@max_price}&MinBedrooms=2&IsBatch=Yes"
      page = 1
      while next_page != "#" do 
        puts "starting scrape for next page \n\n"
        @browser.goto @root + next_page.gsub(@root,'')
        sleep 3
        html = Nokogiri::HTML(@browser.html)
        max_pages = html.css('.pager')[0].css('li a').size
        next_page = (page + 1 > max_pages) ? "#" : (page+=1; "nl/Zoek/ALLE/ALLE/?Page=#{page}&city=(2000-Antwerpen)-(2018-Antwerpen)-(2020-Antwerpen)-(2600-Berchem)-(2610-Wilrijk)&country=Belgique&propertytype=(Opbrengstpand)-(Huis)-(Appartement)&propertysubtype=(Opbrengsteigendom)-(Huis)-(Villa)-(Bungalow)-(Chalet)-(Fermette)-(Herenhuis)-(Kasteel)-(Huis-gemengd-gebruik)-(Appartement)-(Gelijkvloers)-(Penthouse)-(Duplex)-(Triplex)-(Flat---Studio)-(Loft)&transactiontype=(te-koop)-(in-openbare-verkoop)&SortOrder=DefaultAscending&MaxPrice=#{@max_price}&MinBedrooms=2&IsBatch=Yes")
        listings = html.css("div[data-view-type='list'] .property-item")
        scrape_immovlan_listings(listings)
      end
      save_progress if @data.size > 0
      next_scrape
    end

    def scrape_immovlan_listings(listings)
      listings.each_with_index do |listing, index|
        # GENERAL
        begin
          score = 0
          link = listing.css('.u-url').attr("href") ? listing.css('.u-url').attr("href").text.strip : nil
          next if !link
          puts "checking #{link}"
          @browser.goto @root + link
          sleep 3
          html = Nokogiri::HTML(@browser.html)
          is_invalid = html.css("h3.text-center").size > 0 ? !!html.css("h3.text-center").first.text.match(/is niet langer online/) : false
          (puts "skipping, is invalid"; next;) if is_invalid
          address = html.css(".address-line").text.strip + " " + html.css(".city-line").text.strip
          next if !address
          street_matches = @current.find_all{|i| i.normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}.concat(@data.find_all{|i| i[:address].normalize.match(address.normalize.strip.downcase[/^\b\S+\b/])}) # Check if street name has already been scraped
          if street_matches.size > 0
            (puts "skipping, already scraped property"; next;) if street_matches.any? {|street| address[/\b\d{1,3}\b/] === street[/\b\d{1,3}\b/]} # Skip property if street & number matches
          end
          img = html.css(".carousel-item.active img").attr("src").text
          # PRICE
          price = html.css(".price").text.strip.gsub!(/[^0-9]/,"")
          (puts "skipping, no price or invalid format"; next;) if price == nil || !is_numeric?(price)
          score += 1 if Integer(price) < 250000 # bonus point if below 250K
          score += (1 * ((250000 - Integer(price))/20000)) if Integer(price) < 250000 # bonus point for every 20k under 250K
          # BEDS & BATHS
          beds = html.at('div:contains("Slaapkamer(s)")+div') ? html.at('div:contains("Slaapkamer(s)")+div').text.gsub(/\s+/, " ").strip.reverse[/\b\d{1,3}\b/] : nil
          score += 1 if beds && Integer(beds) >= 3 # bonus point if 3 or more beds
          score += (1 * (Integer(beds) - 3)) if beds && Integer(beds) >= 3 # bonus point for every bedroom over 3
          baths = html.at('div:contains("Badkamer(s)")+div') ? html.at('div:contains("Badkamer(s)")+div').text.strip : nil
          # SIZE
          size = html.at('div:contains("Oppervlakte leefruimte")+div') ? html.at('div:contains("Oppervlakte leefruimte")+div').text[/\b\d{1,3}/] : nil
          score += 1 if size && Integer(size) >= 200 # bonus point if more than 200m2
          score += 1 if size && Integer(price)/Integer(size) <= 1300 # bonus point for low m2/price ratio
          # BROKER
          broker =  html.css("a.to-dealer-website")[0] ? html.css("a.to-dealer-website")[0].text.gsub("Aangeboden door:","").strip : html.css(".phone-complete")[0].text.strip
        rescue => error
          (puts "\n #{error}")
          Rails.env.production? ? (puts "FATAL ERROR IN #{@scrapes[@scrape_index].upcase}, GOING TO NEXT"; next;) : (puts "ERROR OCCURED, GOING TO NEXT"; next)
        end
        # Adding Data
        puts "#{address}: BEDS: #{beds}, SIZE: #{size}, PRICE: #{price} => SCORE = #{score}"
        @data << {address: address,beds: beds, baths: baths, size: size, price: price, info: '', status: score, broker: broker, link: @root + link, img: img, coördinates: "", date: Time.now.to_s}
      end
    end
  end

  # ======================================================
  # INIT
  # ======================================================
  begin 
    hunter = HouseHunter.new
    hunter.refresh_token
    hunter.get_current
    hunter.next_scrape
  rescue => error
    (puts "\n #{error}")
    Rails.env.production? ? (puts "FATAL ERROR IN #{@scrapes[@scrape_index].upcase}, GOING TO NEXT"; next_scrape;) : binding.pry
  end
end