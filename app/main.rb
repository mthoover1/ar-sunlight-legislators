require_relative 'models/politician.rb'
# require_relative '../db/config'
require_relative 'models/senator.rb'
require_relative 'models/representative.rb'
require_relative 'models/tweet.rb'
require 'twitter'
require 'json'


Twitter.configure do |config|
  config.consumer_key = 'icSuwtzaGBzwt6G9fhB8g'
  config.consumer_secret = 'TjQgQDV9I6BMMHZn1eplw9monbraIT9Ak5pXQJBiE'
  config.oauth_token = '55737202-rnduIEuLo0jdOZWQWK3oPFb82FO6wa0hgITjA9mAY'
  config.oauth_token_secret = 'uN1cJOK2oDSyKBwJCPa12mqxfyze5yB90zWVIIvdIU'
end


def display_state_politicians(state)
  puts 'Senators:'
  Politician.where("state = ? AND title = ?", state, "Sen").order('lastname').each do |politician|
    puts "   " + politician.firstname + " " + politician.lastname + " (" + politician.party + ")"
  end
  puts 'Representatives:'
  Politician.where("state = ? AND title = ?", state, "Rep").order('lastname').each do |politician|
    puts "   " + politician.firstname + " " + politician.lastname + " (" + politician.party + ")"
  end
end



def politicians_by_gender(input)
  gender = input[0].capitalize
  sen_gender_count = Politician.where("gender = ? AND in_office = ? AND title = ?", gender, 1, "Sen").size
  sen_total_count = Politician.where("in_office = ? AND title = ?", 1, "Sen").size
  rep_gender_count = Politician.where("gender = ? AND in_office = ? AND title = ?", gender, 1, "Rep").size
  rep_total_count = Politician.where("in_office = ? AND title = ?", 1, "Rep").size
  sen_percent = ((sen_gender_count.to_f / sen_total_count) * 100).round(2)
  rep_percent = ((rep_gender_count.to_f / rep_total_count) * 100).round(2)

  puts input.capitalize + " Senators: #{sen_gender_count} (#{sen_percent}%)"
  puts input.capitalize + " Representatives: #{rep_gender_count} (#{rep_percent}%)"

  puts (Politician.male.count.to_f / Politician.count * 100).round(2)
  puts Politician.male.active.count
end


def active_politicians_by_state
  # SELECT
  # state,
  # SUM(title = 'Sen' AND in_office = 1) as Sens,
  # SUM(title = 'Rep' AND in_office = 1) as Reps
  # FROM politicians
  # GROUP BY state;

  states = []
  Politician.all.each do |politician|
    if states.include?(politician.state)
      next
    elsif (politician.title == 'Sen')# && (politician.in_office == 1)
      states << politician.state
    end
  end
  
  states.each do |state|
    puts "#{state}: " + 
    Politician.where("state = ? AND title = 'Sen' AND in_office = 1", state).count.to_s + 
    " Senators, " +
    Politician.where("state = ? AND title = 'Rep' AND in_office = 1", state).count.to_s + 
    " Representatives"
  end
end

def count_politicians
  puts "Senators: " + Politician.where("title = 'Sen'").count.to_s
  puts "Representatives: " + Politician.where("title = 'Rep'").count.to_s
end

def store_tweets_for_id(id)
  politician = Politician.find(id)
  Tweet.where("politician_id = ?", id).destroy_all
  tweets = Twitter.user_timeline(Politician.find(id).twitter_id)
  # politician.tweets = []
  tweets[0..9].each do |tweet|
    politician.tweets << Tweet.create({ text: tweet.text,
                           created_at: tweet.created_at, twitter_post_id: tweet.id,
                           politician_id: id })
  end
end

def display_tweets_for_id(id)
  puts
  politician = Politician.find(id)
  puts "#{politician.title}. #{politician.firstname} #{politician.lastname}  " +
       "#{politician.party}-#{politician.state}"
  politician.tweets.each do |tweet|
    puts "#{tweet.created_at.to_s[0..-10]}:  #{tweet.text}"
  end
end

# Politician.where(:in_office => 0).destroy_all   # DELETED ALL INACTIVE CONGRESS MEMBERS


# display_state_politicians("IL")
# puts
# politicians_by_gender("male")
# puts
# puts Politician.count
# puts
# active_politicians_by_state    # DOES NOT SORT BY NUMBER OF REPS
# puts
# count_politicians


# p Politician.female.count / Politician.count.to_f  



# store_tweets_for_id(184)
# store_tweets_for_id(371)
# store_tweets_for_id(184)
display_tweets_for_id(184)
display_tweets_for_id(371)