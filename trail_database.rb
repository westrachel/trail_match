require "nokogiri"
require "httparty"

class TrailWebScraper
	attr_reader :trail_data

	def initialize(urls)
		@urls = urls
		@trail_data = parse_urls
	end

	def parse_urls
		trail_data = []

		@urls.each do |url|
			webpg = HTTParty.get(url)
			parsed_webpg = Nokogiri::HTML(webpg)

			trailname = parsed_webpg.css('h1.HEAD_LINE').text
			stat_descriptions = parsed_webpg.css('td.i5').text

	  	stats = parsed_webpg.css('td.TD_STATS')
    	raw_trail_stats = stats.css("td.aL").text

    	trail_data << prep_trail_info(trailname, 
    																distance_descriptor(stat_descriptions),
    																raw_trail_stats)
   end
   trail_data
	end

	def prep_trail_info(name, distance_descriptor, stats)
		split_stats = separate_stats(stats)
		{ "name" => name,
			distance_descriptor => split_stats[0],
		  "elevation_gain" => split_stats[2],
		  "avg_round_trip" => split_stats[4]}
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

	def distance_descriptor(string)
		trailhead_index = find_starting_index(string, "T", "Trailhead")
		unneeded_suffix = string[trailhead_index..(string.size - 1)]

		distance_desc_index = find_starting_index(string, "D", "Distance")
		unneeded_prefix = string[0..(distance_desc_index - 1)]

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
p scraper.trail_data