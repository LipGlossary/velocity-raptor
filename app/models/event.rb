class Event < ApplicationRecord
  include Timeslotted
  acts_as_timeslot :scheduled_time, allow_nil: true
  acts_as_timeslot :duration, min: 900

  has_many :blocks, dependent: :destroy

  validates :period, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :title, presence: true, format: /\S+/

  after_save :reschedule_blocks, if: -> { scheduled_time_changed? }
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
    blocks.create(start_time: scheduled_time)
  end

  def reschedule_blocks
    unschedule_blocks
    schedule_blocks
  end
end
