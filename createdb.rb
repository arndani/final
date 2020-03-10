# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :Wedding_Event do
  primary_key :id
  String :title
  String :description, text: true
  String :date
  String :location
end
DB.create_table! :hotel do
  primary_key :id
  foreign_key :hotel_id
  String :description
  String :hotel_name
  String :website
  String :location
end

DB.create_table! :user do
  primary_key :id
  foreign_key :user_id
  Boolean :going
  String :name
  String :email
  String :hotel
end

# Insert initial (seed) data
events_table = DB.from(:Wedding_Event)

events_table.insert(title: "RSVP", 
                    description: "Please let us know if you are able to join us!",
                    date: "September 5",
                    location: "Rome, Italy")

events_table.insert(title: "Hotel Booking", 
                    description: "We have 3 wonderful resort destinations to choose from.",
                    date: "September 5",
                    location: "Nowhere")


                    hotel_table = DB.from(:hotel)

hotel_table.insert(hotel_name: "The Inn at the Spanish Steps", 
                    description: "At the Inn at the Spanish Steps, boutique hospitality in a privileged location on the famed Via Condotti, is part of a new concept combining personalized services with a variety of luxury accommodation tailored to guest’s every desire. ",
                    website: "https://www.theinnatthespanishsteps.com/?gclid=Cj0KCQjw0pfzBRCOARIsANi0g0vkVpU1sw0f1trqbbxpMFIe3pJibaT1evZ974-sZHBKtdygiQi1aW0aAs21EALw_wcB",
                    location: "Via dei Condotti, 85, 00187 Roma RM, Italy")

hotel_table.insert(hotel_name: "Hotel Hassler Roma", 
                    description: "The Hassler Hotel is located in the heart of Rome's City Centre and is the perfect venue for luxury weddings, spa breaks, 5 star conferences, fine dining and more.",
                   website: "https://www.hotelhasslerroma.com/",
                    location: "Piazza della Trinità dei Monti, 6, 00187 Roma RM, Italy")

hotel_table.insert(hotel_name: "Rome Marriott Grand Hotel Flora", 
                    description: "Immerse in your personal Dolce Vita at the Rome Marriott Grand Hotel Flora, right on top of the noble Via Veneto and next door to the Villa Borghese gardens and the 2000 year old historic Roman walls.",
                    website: "https://www.marriott.com/hotels/travel/romdt-rome-marriott-grand-hotel-flora/?scid=bb1a189a-fec3-4d19-a255-54ba596febe2",
                    location: "Via Vittorio Veneto, 191, 00187 Roma RM, Italy")

