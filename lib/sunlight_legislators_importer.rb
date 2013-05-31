require 'csv'
require_relative '../app/models/pol.rb'

class SunlightLegislatorsImporter
  def self.import(filename)
    csv = CSV.new(File.open(filename), :headers => true)
    csv.each do |row|
      keys = []
      values = []
      row.each do |field, value|
        keys << field
        values << value
      end
      pol = Pol.create!(Hash[keys.zip(values)])
    end
  end
end

begin
  raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
  SunlightLegislatorsImporter.import(ARGV[0])
rescue ArgumentError => e
  $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
rescue NotImplementedError => e
  $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
end


# SunlightLegislatorsImporter.import('../db/data/legislators.csv')


