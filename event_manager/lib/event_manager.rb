require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "b9aea72a8da542c58a67db52d0621374"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_homephone(homephone)
	homephone = homephone.to_s.gsub(/[\Wa-zA-Z]/,'')
	if homephone.length > 10 and homephone[0] == "1"
		homephone[1..homephone.length]
	elsif homephone.length == 10
		homephone
	else
		homephone = "0000000000"
	end	
end

def legislators_by_zipcode(zipcode)
	legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"

	filename = "output/thanks_#{id}.html"

	File.open(filename,'w') do |file|
		file.puts form_letter
	end
end

def frequent_hours(dates)
	map = frequency_map_hours(dates)
	return largest_hash_keys(map).collect { |hour,frequency| "#{hour}:00" }
end

def frequent_days(dates)
	map = frequency_map_days(dates)
	return largest_hash_keys(map).collect { |day,frequency| DateTime::DAYNAMES[day.to_i].to_s }
end

def frequency_map_days(dates)
	map = Hash.new(0)
	dates.each do |date|
		map[date.wday.to_s] += 1
	end
	return map
end

def frequency_map_hours(dates)
	map = Hash.new(0)
	dates.each do |date|
		map[date.hour.to_s] += 1
	end
	return map
end

def largest_hash_keys(hash_map)
	hash_map.select { |key,value| value == hash_map.values.max }
end

puts "EventManager Initialized"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter
registration_dates = []
contents.each do |row|
	id = row[0]
	name = row[:first_name]

	zipcode = clean_zipcode(row[:zipcode])
	homephone = clean_homephone(row[:homephone])

	registration_dates << DateTime.strptime(row[:regdate].to_s,'%m/%d/%y %H:%M')

	legislators = legislators_by_zipcode(zipcode)

	form_letter = erb_template.result(binding)

	save_thank_you_letters(id,form_letter)
end

hours = frequent_hours(registration_dates)
puts "Frequent hours of registration are #{hours}"

days = frequent_days(registration_dates)
puts "Frequent days of registration are #{days}"