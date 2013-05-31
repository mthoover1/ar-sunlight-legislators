require_relative '../../db/config'

class Pol < ActiveRecord::Base
  scope :female, where('gender = ?', 'F')
  scope :male, where('gender = ?', 'M')
end
