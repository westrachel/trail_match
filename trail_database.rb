require "nokogiri"
require "httparty"
require "pry"

class TrailWebScraper
	attr_reader :trail_data

	def initialize(urls)
		@urls = urls
		@trail_data = parse_urls
	end

	private

	def parse_urls
		trail_data = []

		@urls.each do |url|
			webpg = HTTParty.get(url)
			parsed_webpg = Nokogiri::HTML(webpg)

			trailname = parsed_webpg.css('h1.HEAD_LINE').text
			stat_descriptions = parsed_webpg.css('td.i5').text

	  	stats = parsed_webpg.css('td.TD_STATS')
    	raw_trail_stats = stats.css("td.aL").text

			distance_desc = find_descriptor(stat_descriptions, "Distance", "Trailhead")
			avg_time_desc = find_descriptor(stat_descriptions, "Avg", "Kokopelli")

    	trail_data << prep_trail_info(trailname, distance_desc, avg_time_desc, 	raw_trail_stats)
   end
   trail_data
	end

	def prep_trail_info(name, distance_descriptor, avg_time_descriptor, stats)
		split_stats = separate_stats(stats)
		current_distance = split_stats[0]
		full_distance = distance_round_trip(distance_descriptor, current_distance)
		avg_time = avg_time_round_trip(avg_time_descriptor, split_stats[4])

		{ name: name,
		  distance_round_trip: full_distance,
		  elevation_gain: stat_as_integer(split_stats[2], "feet"),
		  avg_round_trip_time: avg_time }
	end

	def avg_time_round_trip(descriptor, time_string)
		multiplier = round_trip_multiplier(descriptor)
		return nil if (multiplier == -1 || time_string.nil?)

		unit = time_string.chars.select { |char| char =~ /[a-z]/i }.join('')
		dividor = unit =~ /(hour)/ ? 1 : 60

		(string_to_number(time_string) / dividor * multiplier).round(2)
	end

	def distance_round_trip(descriptor, distance)
		multiplier = round_trip_multiplier(descriptor)
		return nil if (multiplier == -1 || distance.nil?)
		
		string_to_number(distance) * multiplier
	end

	def round_trip_multiplier(descriptor)
		if descriptor =~ /(One Way)/
			2
		elsif descriptor =~ /(Round Trip)/
			1
		else
			-1
		end
	end

	def string_to_number(measurement)
		measurement.chars.select { |char| char =~ /[0-9.\-]/ }.join('').to_f
	end

	def stat_as_integer(stat, unit_to_remove)
		return nil if stat.nil?
		stat.delete(unit_to_remove).delete(",").to_i
	end

	def find_starting_index(string, starting_letter, word)
		addend = word.length - 1
		desired_index = 0
		string.chars.each_with_index do |char, index|
			if char == starting_letter && string[index..(index+addend)] == word
				desired_index = index
			end
		end
		desired_index
	end

	def find_descriptor(string, first_word, suffix_first_word)
		suffix_letter = suffix_first_word[0]
		suffix_starting_index = find_starting_index(string, suffix_letter, suffix_first_word)

		unneeded_suffix = string[suffix_starting_index..(string.size - 1)]

	  desired_desc_index = find_starting_index(string, first_word[0], first_word)
		unneeded_prefix = string[0..(desired_desc_index - 1)]

		string.delete_suffix(unneeded_suffix).delete_prefix(unneeded_prefix)
	end

	def separate_stats(stats)
		breakpoints = find_breakpts(stats)

		index = 0
		breakpoints.each_with_object([]) do |breakpt, arr|
			arr << stats[index..breakpt]
			index = breakpt + 1
		end
	end

	def last_char_of_single_stat?(character, index, string)
		rt_neighbor = string[index + 1]
		left_neighbor = string[index - 1]

		condition_1 = character =~ /[a-z]/i
		condition_2 = rt_neighbor == rt_neighbor.to_i.to_s
		condition_3 = character != " "
		condition_4 = left_neighbor =~ /[a-z]/i

		condition_1 && condition_2 && condition_3 && condition_4
	end

	def find_breakpts(stats)
		breakpts = []
		characters = stats.chars
		characters.each_with_index do |char, idx|
			breakpts << idx if last_char_of_single_stat?(char, idx, stats)
		end
		breakpts
	end
end

urls = ["https://hikearizona.com/decoder.php?ZTN=19215",
	      "https://hikearizona.com/decoder.php?ZTN=16388",
	      "https://hikearizona.com/decoder.php?ZTN=19950",
	      "https://hikearizona.com/decoder.php?ZTN=828",
	      "https://hikearizona.com/decoder.php?ZTN=713",
	      "https://hikearizona.com/decoder.php?ZTN=16353",
	      "https://hikearizona.com/decoder.php?ZTN=673",
	      "https://hikearizona.com/decoder.php?ZTN=21",
	      "https://hikearizona.com/decoder.php?ZTN=17581",
	      "https://hikearizona.com/decoder.php?ZTN=20142",
	      "https://hikearizona.com/decoder.php?ZTN=861",
	      "https://hikearizona.com/decoder.php?ZTN=1038",
	      "https://hikearizona.com/decoder.php?ZTN=16624",
	      "https://hikearizona.com/decoder.php?ZTN=15257",
	      "https://hikearizona.com/decoder.php?ZTN=16362",
	      "https://hikearizona.com/decoder.php?ZTN=819",
	      "https://hikearizona.com/decoder.php?ZTN=1455",
	      "https://hikearizona.com/decoder.php?ZTN=2033",
	      "https://hikearizona.com/decoder.php?ZTN=289",
	      "https://hikearizona.com/decoder.php?ZTN=17085",
	      "https://hikearizona.com/decoder.php?ZTN=95",
	      "https://hikearizona.com/decoder.php?ZTN=13",
	      "https://hikearizona.com/decoder.php?ZTN=61",
	      "https://hikearizona.com/decoder.php?ZTN=1422",
	      "https://hikearizona.com/decoder.php?ZTN=374",
	      "https://hikearizona.com/decoder.php?ZTN=16311",
	      "https://hikearizona.com/decoder.php?ZTN=152",
	      "https://hikearizona.com/decoder.php?ZTN=20983",
	      "https://hikearizona.com/decoder.php?ZTN=686",
	      "https://hikearizona.com/decoder.php?ZTN=1459",
	      "https://hikearizona.com/decoder.php?ZTN=2074"]

scraper = TrailWebScraper.new(urls)


File.open("schema.sql", "w+") do |f| 
	f.write(<<~SQL
  	CREATE TABLE trails (
  		id serial PRIMARY KEY,
  		name text NOT NULL,
  		distance_round_trip decimal(4,2),
  		distance_units varchar(20) DEFAULT 'miles',
  		elevation_gain integer,
  		avg_round_trip_time decimal(4, 2),
  		avg_rtt_units varchar(20) DEFAULT 'hours'
  	);

		CREATE TABLE users (
			id serial PRIMARY KEY,
			name text NOT NULL,
			password text NOT NULL
		);

		CREATE TABLE users_trails (
			id serial PRIMARY KEY,
			favorited_trail_flag boolean DEFAULT FALSE,
			number_of_visits integer,
			trail_id integer NOT NULL,
			user_id integer NOT NULL,
			FOREIGN KEY (trail_id) REFERENCES trails (id) ON DELETE CASCADE,
			FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
		);
SQL
)

def prevent_blank_from_interpolation(value)
	value.nil? ? "NULL" : value
end

	scraper.trail_data.each do |trail|
		prepped_name = trail[:name].gsub("'", "''")
		prepped_distance = prevent_blank_from_interpolation(trail[:distance_round_trip])
		prepped_ev_gain = prevent_blank_from_interpolation(trail[:elevation_gain])
		prepped_avg_rtt = prevent_blank_from_interpolation(trail[:avg_round_trip_time])
		
		f.write(<<~SQL
			INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
				VALUES ('#{prepped_name}', #{prepped_distance}, #{prepped_ev_gain}, #{prepped_avg_rtt});
		SQL
		)
	end
end