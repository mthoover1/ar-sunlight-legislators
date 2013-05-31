require_relative 'models/pol.rb'

require 'pry'

def display_state_pols(state)
  puts 'Senators:'
  Pol.where("state = ? AND title = ?", state, "Sen").order('lastname').each do |pol|
    puts "   " + pol.firstname + " " + pol.lastname + " (" + pol.party + ")"
  end
  puts 'Representatives:'
  Pol.where("state = ? AND title = ?", state, "Rep").order('lastname').each do |pol|
    puts "   " + pol.firstname + " " + pol.lastname + " (" + pol.party + ")"
  end
end



def pols_by_gender(input)
  gender = input[0].capitalize
  sen_gender_count = Pol.where("gender = ? AND in_office = ? AND title = ?", gender, 1, "Sen").size
  sen_total_count = Pol.where("in_office = ? AND title = ?", 1, "Sen").size
  rep_gender_count = Pol.where("gender = ? AND in_office = ? AND title = ?", gender, 1, "Rep").size
  rep_total_count = Pol.where("in_office = ? AND title = ?", 1, "Rep").size
  sen_percent = ((sen_gender_count.to_f / sen_total_count) * 100).round(2)
  rep_percent = ((rep_gender_count.to_f / rep_total_count) * 100).round(2)

  puts input.capitalize + " Senators: #{sen_gender_count} (#{sen_percent}%)"
  puts input.capitalize + " Representatives: #{rep_gender_count} (#{rep_percent}%)"
end


def active_pols_by_state
  # SELECT
  # state,
  # SUM(title = 'Sen' AND in_office = 1) as Sens,
  # SUM(title = 'Rep' AND in_office = 1) as Reps
  # FROM pols
  # GROUP BY state;

  states = []
  Pol.all.each do |pol|
    if states.include?(pol.state)
      next
    elsif (pol.title == 'Sen')# && (pol.in_office == 1)
      states << pol.state
    end
  end
  
  states.each do |state|
    puts "#{state}: " + 
    Pol.where("state = ? AND title = 'Sen' AND in_office = 1", state).count.to_s + 
    " Senators, " +
    Pol.where("state = ? AND title = 'Rep' AND in_office = 1", state).count.to_s + 
    " Representatives"
  end
end

def count_pols
  puts "Senators: " + Pol.where("title = 'Sen'").count.to_s
  puts "Representatives: " + Pol.where("title = 'Rep'").count.to_s
end



# Pol.where(:in_office => 0).destroy_all   # DELETED ALL INACTIVE CONGRESS MEMBERS


display_state_pols("IL")
puts
pols_by_gender("male")
puts
active_pols_by_state    # DOES NOT SORT BY NUMBER OF REPS
puts
count_pols


# p Pol.female.count / Pol.count.to_f  



