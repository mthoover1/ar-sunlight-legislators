require_relative '../../db/config'

class Politician < ActiveRecord::Base
  has_many :tweets, :dependent => :destroy


  scope :female, where('gender = ?', 'F')
  scope :male, where('gender = ?', 'M')
  # scope :reps, where ('title = ?', 'Rep')
  # scope :sens, where ('title = ?', 'Sen')
  # scope :active, where ('in_office == 1')
end
