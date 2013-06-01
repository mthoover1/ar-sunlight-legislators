require_relative '../config'


class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :title
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :party
      t.string :state
      t.string :district
      t.string :in_office
      t.string :gender
      t.string :phone
      t.string :fax
      t.string :website
      t.string :webform
      t.string :twitter_id
      t.date   :birthdate

      t.string :congress_type
    end
  end
end
