class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      # t.belongs_to :twitter_user, index: true
      t.integer :id_tweet
      t.timestamp :created_at
      t.text :tweet
      t.timestamp
    end
  end
end
