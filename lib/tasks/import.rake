require 'csv'

# Example: rake gtfs_import["/Users/Keanu/Downloads/GRT_GTFS"]
desc "Imports a CSV file into an ActiveRecord table"
task :gtfs_import, [:path] => :environment do |task,args|

	{
		"calendar.txt" 		=> "Calendar",
		"routes.txt"			=> "Route",
		"stops.txt"				=> "Stop",
		"trips.txt"				=> "Trip",
		"stop_times.txt"	=> "StopTime"
	}.each do |file, model|

		puts "Clearing #{model}..."

		Module.const_get(model).delete_all

	  puts "Importing #{file}..."

		CSV.foreach(File.join(args[:path], file), :headers => true) do |row|
	    attributes = Hash[row]
	    Module.const_get(model).create(attributes)
	  end

	  puts "Done importing #{file}"
	end
end
