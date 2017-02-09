# == Schema Information
#
# Table name: submitters
#
#  id           :integer          not null, primary key
#  submitter_id :integer          not null
#  url_id       :integer          not null
#

class Submitter < ActiveRecord::Base
  validates :submitter_id, :url_id, presence: true

  belongs_to(
    :submitter, {
      class_name: :User,
      primary_key: :id,
      foreign_key: :submitter_id
    }
  )

  belongs_to(
    :url, {
      class_name: :ShortenedUrl,
      primary_key: :id,
      foreign_key: :url_id
    }
  )
end
