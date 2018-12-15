class Block < ApplicationRecord
  include Timeslotted
  acts_as_timeslot :duration, min: 900
  acts_as_timeslot :start_time

  default_scope { order(start_time: :asc) }

  belongs_to :event

  validates :title, allow_nil: true, format: /\S+/

  before_save :clean_event_fields, if: :scheduled_block?

  def duration
    event&.duration || self[:duration]
  end

  def title
    event&.title || self[:title]
  end

  def title=(val)
    self[:title] = val
  end

  def scheduled_block?
    event.present?
  end

  private

  def clean_event_fields
    self[:duration] = nil
    self[:title] = nil
  end
end
