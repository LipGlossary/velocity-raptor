class Event < ApplicationRecord
  include Timeslotted

  alias_attribute :start_time, :scheduled_time

  has_many :blocks, dependent: :destroy

  validates :period, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :scheduled_time, allow_nil: true, timeslot: true
  validates :title, presence: true, format: /\S+/

  def start_times
    blocks.pluck(:start_time)
  end
end
