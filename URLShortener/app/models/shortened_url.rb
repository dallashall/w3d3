# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string
#  long_url   :string
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true

  def self.random_code
    new_code = SecureRandom::urlsafe_base64(12)
    self.exists?(short_url: new_code) ? self.random_code : new_code
  end

  def self.new_shortened_url(user, url_string)
    short_url = self.create!(
      long_url: url_string,
      short_url: self.random_code
    )
    Submitter.create(submitter_id: user.id, url_id: short_url.id)
    short_url
  end

  has_one(
    :submission, {
      class_name: :Submitter,
      primary_key: :id,
      foreign_key: :url_id
    }
  )
  has_one(
    :submitter, {
      through: :submission,
      source: :submitter
    }
  )
  has_many(
    :visits, {
      class_name: :Visit,
      primary_key: :id,
      foreign_key: :url_id
    }
  )
  has_many(
    :visitors,
    Proc.new { distinct }, {
      through: :visits,
      source: :user
    }
  )

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.select(:visitor_id).distinct.where(
      "created_at > '#{10.minutes.ago}'"
    ).count
  end
end
