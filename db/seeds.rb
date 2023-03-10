# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)



ana = Artist.new(name: "ana", description: "Monteiro")
carolina = Artist.new(name: "carolina", description: "Monteiro")


Concert.create!(location: "lisbon", description: "Great show", date: DateTime.new(2009,9,1,17), price: 5, ticket_url: "www.hts", artist: ana)
Concert.create!(location: "azores", description: "Jazz", date: DateTime.new(2009,9,1,17), price: 2, ticket_url: "www.hts", artist: carolina)
Concert.create!(location: "faro", description: "Blues", date: DateTime.new(2009,9,1,17), price: 5, ticket_url: "www.hts", artist: ana)



# t.string "location"
# t.text "description"
# t.date "date"
# t.float "price"
# t.string "ticket_url"
