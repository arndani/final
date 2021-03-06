# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"   
require "geocoder"                                                            #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

#my_password = BCrypt::Password.create("my password")
#=> "$2a$12$K0ByB.6YI2/OYrB4fQOYLe6Tv0datUVf6VZ/2Jzwm879BW5K1cHey"
#my_password = BCrypt::Password.new("$2a$12$K0ByB.6YI2/OYrB4fQOYLe6Tv0datUVf6VZ/6VZ/2Jzwm879BW5K1cHey")
#my_password == "my password" #=> true
#my_password == "not my password" #=> false

wedding_table = DB.from(:Wedding_Event)
hotel_table = DB.from(:hotel)
user_table = DB.from(:user)


account_sid = "ACd9b98685d9fc4d9075cd1310081e521f"
auth_token = "Show"


client = Twilio::REST::Client.new(account_sid, auth_token)

# send the SMS from your trial Twilio number to your verified non-Twilio number
#client.messages.create(
 #from: "+18326481436", 
 #to: "+6302177912",
 #body: "RSVP Sent!"

get "/" do
    puts "params: #{params}"

    pp wedding_table.all.to_a
    @wedding = wedding_table.all.to_a
    view "Wedding_page"
end


get "/wedding/:id" do
    puts "params: #{params}"

    pp wedding_table.where(id: params[:id]).to_a[0]
    @details = wedding_table.where(id: params[:id]).to_a[0]
    @hotel=hotel_table.where(id: params[:id]).to_a[0]
    if@details[:id] == 1 then
       
        view "RSVP"
    elsif @details[:id] == 2 then
      
        view "Hotels"
    else
        view "search"
    end
end


get "/wedding/:id/load" do
    puts params

 user_table.insert(going: params["going"], 
                      name: params["name"],
                      email: params["email"])

view "Submitted"
end

get "/wedding/:id/load2" do
    puts params


    user_table.insert(name: params["name"],
                      email: params["email"],
                      hotel: params["hotel"])
view "Submitted"
end

get "/wedding/map" do


 @details = wedding_table.where(id: params[:id]).to_a[0]
    @hotel=hotel_table.where(id: params[:id]).to_a[0]
    

    view "search"
    
end


get "/wedding/map/view" do
    @test=params["cars"]
    results = Geocoder.search(params["cars"])
    lat_long = results.first.coordinates # => [lat, long]
      @lat = lat_long[0]
  @long =  lat_long[1]
  @lat_long = "#{@lat},#{@long}"
    "#{lat_long[0]} #{lat_long[1]}"
    view "where2"
end