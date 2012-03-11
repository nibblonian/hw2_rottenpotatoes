class Movie < ActiveRecord::Base
  def self.ratings
    all(:group => 'rating', :select => 'rating').map {|row| row.rating}
  end
end
