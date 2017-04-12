class Event < ApplicationRecord
  include ActiveModel::Validations

  class TimeslotValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.respond_to?(:%) && (value % 15.minutes).zero?
        record.errors.add attribute, "is not an even 15 minute interval"
      end
    end
  end

  validates :title, presence: true, format: /\S+/
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 15.minutes }, timeslot: true
  validates :period, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :scheduled_time, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }, timeslot: true
end
