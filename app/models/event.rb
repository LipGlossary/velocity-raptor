class Event < ApplicationRecord
  include Timeslotted
  acts_as_timeslot :scheduled_time, allow_nil: true
  acts_as_timeslot :duration, min: 900

  has_many :blocks, dependent: :destroy

  validates :period, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :title, presence: true, format: /\S+/

  def start_times
    blocks.pluck(:start_time)
  end
end
