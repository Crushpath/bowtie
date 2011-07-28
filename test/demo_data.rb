def add_places!(city)
	city.places << Cinema.create(:name => "Busterblock", :address => "234 Mission St")
	city.places << Restaurant.create(:name => "Freddo's", :address => "123 Park Lane")
end

def add_demo_data!
	city = City.create(:name => "Shangri-La")
	major = Major.create(:name => "John Lennon")
	city.major = major
	major.save
	add_places!(city)
end
