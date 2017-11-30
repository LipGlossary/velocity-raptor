class Event < ApplicationRecord
  FORECAST_MAX = 5.years.freeze

  include Timeslotted
  acts_as_timeslot :scheduled_time, :allow_nil
  acts_as_timeslot :duration, :relative, min: 900
  acts_as_timeslot :period, :relative, :allow_nil

  has_many :blocks, dependent: :destroy

  validates :title, presence: true, format: /\S+/
  validate :period_cannot_be_less_than_duration, if: -> { period && period < duration }

  after_save :reschedule_blocks, if: -> { scheduled_time_changed? || period_changed? }
  after_destroy :unschedule_blocks

  def scheduled?
    scheduled_time.present?
  end

  def start_times
    blocks.pluck(:start_time)
  end

  private

  def unschedule_blocks
    blocks.destroy_all
  end

  def schedule_blocks
    return unless scheduled_time

    start = scheduled_time.to_i
    forecast = FORECAST_MAX.since.to_i
    step = (period || forecast).to_i

    (start...forecast).step(step) do |time|
      blocks.create(start_time: time)
    end
  end

  def reschedule_blocks
    unschedule_blocks
    schedule_blocks
  end

  def period_cannot_be_less_than_duration
    errors.add(:period, "can't be less than duration")
  end
end
