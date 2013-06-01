class AddTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer  :id
      t.string   :text
      t.datetime :created_at
      t.integer  :politician_id
    end
  end
end
