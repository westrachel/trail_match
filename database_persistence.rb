require "pg"

class DatabasePersistence
	def initialize(tracker)
		@db = PG.connect(dbname: "trail_match")
		@logger = tracker
	end

	def query(sql, *parameters)
		@logger.info "#{sql}: #{parameters}"
		@db.exec_params(sql, parameters)
	end

	def sort_trails(trait, sort_order)
		query("SELECT * FROM trails ORDER BY $1 $2;", trait, sort_order)
	end

	def all_trails
		sql = "SELECT * FROM trails;"
		data = query(sql)
		data.map do |tuple|
			{ id: tuple["id"].to_i,
		 	  name: tuple["name"],
		 	  distance_round_trip: tuple["distance_round_trip"],
		 	  elevation_gain: tuple["elevation_gain_ft"],
		 	  avg_round_trip_time: tuple["avg_round_trip_time"]
		 	}
		end
	end
end