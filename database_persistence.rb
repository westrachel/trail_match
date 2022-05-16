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

	def sql_select(end_of_statement)
    <<~SQL
      SELECT id, name, distance_round_trip,
      			 elevation_gain_ft, avg_round_trip_time
      	FROM trails#{end_of_statement}
    SQL
	end

	def sort_trails(column, sort_order)
		end_clause = sort_order == "DESC" ? "$1 DESC;" : "$1;"
		command = sql_select(" ORDER BY #{end_clause}")
		data = query(command, column)
		format_query_result(data)
	end

	def all_trails
		result = query(sql_select(";"))
    format_query_result(result)
	end

	def format_query_result(data)
		data.map do |tuple|
			{ id: tuple["id"].to_i,
		 	  name: tuple["name"],
		 	  distance_round_trip: tuple["distance_round_trip"],
		 	  elevation_gain: tuple["elevation_gain_ft"],
		 	  avg_round_trip_time: tuple["avg_round_trip_time"]
		 	}
		end
	end

	def number_trails
		all_trails.size
	end
end