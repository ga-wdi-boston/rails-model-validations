places = Place.where('state = \'MA\'')
places.each { |place| p place }