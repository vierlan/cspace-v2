venues = Venue.all
venues.each do |venue|
  if venue.categories == "bar"
    venue.update(spaces: {"work" => false, "study" => false, "meeting" => true})
  elsif venue.categories == "cafe"
    venue.update(spaces: {"work" => true, "study" => false, "meeting" => false})
  else
    venue.update(spaces: {"work" => false, "study" => true, "meeting" => false})
  end
end

# heroku run rails runner ./add_spaces_script.rb
