class Block < ApplicationRecord
  include Timeslotted

  default_scope { order(start_time: :asc) }

  belongs_to :event

  validates :start_time, presence: true
  validates :title, allow_nil: true, format: /\S+/
end
