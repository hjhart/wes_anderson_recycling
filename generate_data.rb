def get_cast (id)
  require 'yaml'
  require 'open-uri'
  require 'json'
  
  config = YAML::load File.open('api_key.yml')
  apikey = config['apikey']
  link = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{id}/cast.json?apikey=#{apikey}"
  
  JSON.parse open(link).read  
end


require 'awesome_print'
# http://www.rottentomatoes.com/celebrity/wes_anderson/ might be able to scrape it from this page using nokogiri or hpricot.

cast_members = Hash.new { |hash, key| hash[key] = [] }
wes_anderson_movie_ids = {
  "Fantastic Mr. Fox" => 770685760, 
  "Darjeeling Limited" => 770670652,
  "Hotel Chevalier" => 770676438,
  "Life Aquatic" => 12895,
  "Royal Tenenbaums" => 12907, 
  "Rushmore" => 12953,
  "Bottle Rocket" => 12952
}

wes_anderson_movie_ids.each do |movie_name, movie_id| 
  cast_list = get_cast movie_id
  cast_list["cast"].each do |cast| 
    cast_members[cast["name"]] << movie_name
  end
end

cast_members = cast_members.select { |cast, movies| movies.size > 1 }

File.open('wes_anderson_data.json', 'w') { |file|
  file.puts cast_members.to_json
}



# http://www.rottentomatoes.com/m/1197696-fantastic_mr_fox/ 770685760
# http://www.rottentomatoes.com/m/darjeeling_limited/ 770670652
# http://www.rottentomatoes.com/m/hotel-chevalier/ 770676438
# http://www.rottentomatoes.com/m/life_aquatic/ 12895
# http://www.rottentomatoes.com/m/royal_tenenbaums/ 12907
# http://www.rottentomatoes.com/m/rushmore/ 12953
# http://www.rottentomatoes.com/m/bottle_rocket/ 12952



