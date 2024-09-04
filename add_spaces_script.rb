venues = Venue.all
venues.each do |venue|
  if venue.categories == "Bar"
    venue.update(spaces: {"work" => false, "study" => false, "meeting" => true})
  elsif venue.categories == "Cafe"
    venue.update(spaces: {"work" => true, "study" => false, "meeting" => false})
  else
    venue.update(spaces: {"work" => false, "study" => true, "meeting" => false})
  end
end
