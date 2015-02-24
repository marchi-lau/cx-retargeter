require 'bundler/setup'
require 'sinatra'
require 'pony'

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
  @date_departure = params[:date_departure]
  @date_return = params[:date_return]
  @cabin = params[:cabin]
  
  Pony.mail(:to => "ecxmtl@gmail.com", 
            :subject => "Make a booking now - from #{@origin} to #{@destination}", 
            :html_body => erb(:template))
end

post '/mailer' do
  @destination = params[:destination]
  @origin = params[:origin]
  @date_departure = params[:date_departure]
  @date_return = params[:date_return]
  @cabin = params[:cabin]
  
  Pony.mail(:to => "ecxmtl@gmail.com", 
            :subject => "Make a booking now - from #{@origin} to #{@destination}", 
            :html_body => erb(:template))
end

get '/template' do 
  erb(:template)
end