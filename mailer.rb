require 'bundler/setup'
require 'sinatra'
require 'pony'
require 'httparty'
require 'nokogiri'
require 'open-uri'
Pony.options = {:from => 'news@cathaypacific.com', 
                :via => :smtp, :via_options => {
                :address        => 'mailtrap.io',
                :port           => '2525',
                :user_name      => '30203e90b0e47a600',
                :password       => '04ac6b5291528c',
                :authentication => :cram_md5, # :plain, :login, :cram_md5, no auth by default
                :domain         => "mailtrap.io" # the HELO domain provided by the client to the server
                }
               }

# Pony.options = { :from => 'news@cathaypacific.com', :via => :smtp, :via_options => {
#     :address        => 'smtp.gmail.com',
#     :port           => '587',
#     :enable_starttls_auto => true,
#     :user_name      => 'ecxmtl@gmail.com',
#     :password       => 'Qqweasdzxc123*',
#     :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
#     :domain         => "localhost" # the HELO domain provided by the client to the server
#   } }


get '/' do
  erb :index
end

get '/mailer*' do
  @destination = params[:destination]
  @origin = params[:origin]
  @date_departure = params[:date_departure].gsub('-','')
  @date_return = params[:date_return].gsub('-','')
  @cabin = params[:cabin]
  @trip_type = params[:trip_type] || "R"
  @pax_adult = params[:pax_adult].to_i
  @pax_child = params[:pax_child].to_i
  @pax_infant = params[:pax_infant].to_i
  @country = params[:country]
  @language = params[:language]
  @tier = params[:tier]
  @asia_miles = params[:asia_miles]
  @club_sectors = params[:club_sectors]
  @club_miles = params[:club_miles]
  @title = params[:title]
  @first_name = params[:first_name]
  @airports = JSON.parse(HTTParty.get("http://assets.cathaypacific.com/json/destinations/airports.json").body)['airports']
  @destination_name = @airports.select{|airport| airport['airportCode'] == @destination}[0]['airportDetails']['city']['name']

 # Preferrably to have an airport_code.html
 #things-to-do.html?airport=xxx // city=xxx
  puts @url = "http://www.cathaypacific.com/cx/en_HK/destinations/things-to-do-in-#{@destination_name.downcase.gsub(' ','-')}.html"
  html = Nokogiri::HTML(open(@url))
  @image_left = 'http://www.cathaypacific.com' + html.css("div.item")[1].at_css("img")['src']
  @title_left = html.css("div.item")[1].at_css("div.title").text
  @intro_left = html.css("div.item")[1].at_css("div.intro").text.strip
  @category_left = html.css("div.item")[1].at_css("div.category").text
  @image_right = 'http://www.cathaypacific.com' + html.css("div.item")[0].at_css("img")['src']
  @title_right = html.css("div.item")[0].at_css("div.title").text
  @category_right = html.css("div.item")[0].at_css("div.category").text
  @intro_right = html.css("div.item")[0].at_css("div.intro").text.strip

  @deeplink = "http://www.cathaypacific.com/wdsibe/IBEFacade?ACTION=SINGLECITY_SEARCH&FLEXIBLEDATE=true&BOOKING_FLOW=REVENUE&ENTRYLANGUAGE=#{@language}&ENTRYPOINT=http%3A%2F%2Fwww.qunar.com&ENTRYCOUNTRY=#{@country}&RETURNURL=http://www.cathaypacific.com:80/cx/en_US/_jcr_content.handler.html&ERRORURL=http://www.cathaypacific.com:80/cx/en_US/_jcr_content.handler.html&ORIGIN=#{@origin}&DESTINATION=#{@destination}&DEPARTUREDATE=#{@date_departure}&ARRIVALDATE=#{@date_return}&TRIPTYPE=#{@trip_type}&CABINCLASS=#{@cabin}&ADULT=#{@pax_adult}&CHILD=#{@pax_child}&INFANT=#{@pax_infant}"
  
  Pony.mail(:to => "ecxmtl@gmail.com", 
            :subject => "Make a booking now - from #{@origin} to #{@destination}", 
            :html_body => erb(:template))
end

post '/mailer' do
  @destination = params[:destination]
  @origin = params[:origin]
  @date_departure = params[:date_departure].gsub('-','')
  @date_return = params[:date_return].gsub('-','')
  @cabin = params[:cabin]
  @trip_type = params[:trip_type] || "R"
  @pax_adult = params[:pax_adult].to_i
  @pax_child = params[:pax_child].to_i
  @pax_infant = params[:pax_infant].to_i
  @country = params[:country]
  @language = params[:language]
  @tier = params[:tier]
  @asia_miles = params[:asia_miles]
  @club_sectors = params[:club_sectors]
  @club_miles = params[:club_miles]
  @title = params[:title]
  @first_name = params[:first_name]
  @airports = JSON.parse(HTTParty.get("http://assets.cathaypacific.com/json/destinations/airports.json").body)['airports']
  @destination_name = @airports.select{|airport| airport['airportCode'] == @destination}[0]['airportDetails']['city']['name']

  puts @url = "http://www.cathaypacific.com/cx/en_HK/destinations/things-to-do-in-#{@destination_name.downcase.gsub(' ','-')}.html"
  html = Nokogiri::HTML(open(@url))
  @image_left = 'http://www.cathaypacific.com' + html.css("div.item")[1].at_css("img")['src']
  @title_left = html.css("div.item")[1].at_css("div.title").text
  @intro_left = html.css("div.item")[1].at_css("div.intro").text.strip
  @category_left = html.css("div.item")[1].at_css("div.category").text
  @image_right = 'http://www.cathaypacific.com' + html.css("div.item")[0].at_css("img")['src']
  @title_right = html.css("div.item")[0].at_css("div.title").text
  @category_right = html.css("div.item")[0].at_css("div.category").text
  @intro_right = html.css("div.item")[0].at_css("div.intro").text.strip

  @deeplink = "http://www.cathaypacific.com/wdsibe/IBEFacade?ACTION=SINGLECITY_SEARCH&FLEXIBLEDATE=true&BOOKING_FLOW=REVENUE&ENTRYLANGUAGE=#{@language}&ENTRYPOINT=http%3A%2F%2Fwww.qunar.com&ENTRYCOUNTRY=#{@country}&RETURNURL=http://www.cathaypacific.com:80/cx/en_US/_jcr_content.handler.html&ERRORURL=http://www.cathaypacific.com:80/cx/en_US/_jcr_content.handler.html&ORIGIN=#{@origin}&DESTINATION=#{@destination}&DEPARTUREDATE=#{@date_departure}&ARRIVALDATE=#{@date_return}&TRIPTYPE=#{@trip_type}&CABINCLASS=#{@cabin}&ADULT=#{@pax_adult}&CHILD=#{@pax_child}&INFANT=#{@pax_infant}"
  
  Pony.mail(:to => "ecxmtl@gmail.com", 
            :subject => "Make a booking now - from #{@origin} to #{@destination}", 
            :html_body => erb(:template))
end

get '/template' do 
  erb(:template)
end