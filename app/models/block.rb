class Block < ApplicationRecord
  include Timeslotted

  default_scope { order(start_time: :asc) }

  belongs_to :event

  validates :start_time, presence: true
  validates :title, allow_nil: true, format: /\S+/

  def duration
    event&.duration || self[:duration]
  end

  def title
    event&.title || self[:title]
  end

  def title=(val)
    self[:title] = val
  end
end
