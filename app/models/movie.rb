class Movie < ActiveRecord::Base

	def self.get_all_ratings
		self.select("DISTINCT rating").map(&:rating)
	end	


end