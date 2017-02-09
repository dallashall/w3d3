class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :short_url
      t.string :long_url, null: false

      t.timestamps
    end
    add_index :shortened_urls, :short_url
  end
end
