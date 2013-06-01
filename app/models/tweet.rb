require_relative '../../db/config'
# require_relative 'politician.rb'

class Tweet < ActiveRecord::Base
  belongs_to :politician

  validates :twitter_post_id, :uniqueness => :true
end

