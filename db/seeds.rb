require 'faker'

puts "Cleaning database.."
Genre.destroy_all
Artist.destroy_all

puts "Database cleaned"

genres = %w[afro-funk acid-jazz ambient anti-folk anatolian-rock baroque hiphop blues boogie-woogie celctic jazz]

puts "Creating genres.."

genres.each do |genre|
  Genre.create(name: genre)
end

puts "#{Genre.all.count} genre's created"

puts "Creating artists.."

10.times do
  name = Faker::Music.band
  description = Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4)
  Artist.create!(name:, description:)
end

puts "#{Artist.count} artists created"

puts "Assigning genres to artists.."

artists = Artist.all
artists.each do |artist|
  rand(1..4).times do
    artist_genre = ArtistGenre.new
    artist_genre.artist = artist
    artist_genre.genre = Genre.all.sample
    artist_genre.save
  end
  puts "Assigned #{artist.genres.count} genres to #{artist.name}"
end

puts "Creating concerts.."

8.times do
  artist = artists.sample
  location = ["Lisbon", "Barcelona", "Berlin", "London", "Beijing", "Porto", "Azores", "Paris"]
  description = Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4)
  price = rand(20..100)
  date = Faker::Date.forward(days: 60)
  ticket_url = "https://concertify.app"
  concert = Concert.new
  concert.location = location.sample
  concert.latitude = Faker::Address.latitude
  concert.longitude = Faker::Address.longitude
  concert.description = description
  concert.price = price
  concert.ticket_url = ticket_url
  concert.date = date
  concert.artist = artist
  concert.tm_id = Faker::Code.npi
  concert.save
end

puts "Created #{Concert.count} and assigned them to artists"

puts "Assiging followed artists and saved concerts for each user.."

User.all.each do |user|
  rand(3..5).times do
    followed_artist = FollowedArtist.new
    followed_artist.user = user
    followed_artist.artist = Artist.all.sample
    followed_artist.save
    saved_concert = SavedConcert.new
    saved_concert.user = user
    saved_concert.concert = Concert.all.sample
    saved_concert.save
  end
  puts "Assigned #{user.followed_artists.count} followed artists to #{user.email}"
  puts "Assigned #{user.saved_concerts.count} saved concerts to #{user.email}"
end
