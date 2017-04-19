module Timeslotted
  extend ActiveSupport::Concern

  class TimeslotValidator < ActiveModel::Validations::NumericalityValidator
    def validate_each(record, attr_name, value)
      super

      return if record.errors.any?
      return if options[:allow_nil] && value.nil?

      unless 0 <= value
        record.errors.add attr_name, "must be greater than or equal to 0"
        return
      end

      unless (value % 15.minutes).zero?
        record.errors.add attr_name, "is not an even 15 minute interval"
      end
    end
  end

  included do
    include ActiveModel::Validations

    def duration
      self[:duration]
    end

    def duration=(val)
      self[:duration] = [round_to_timeslot(time: val), 900].max
    end

    def start_time
      self[:start_time]
    end

    def start_time=(val)
      self[:start_time] = round_to_timeslot(time: val)
    end

    validates :duration, presence: true, numericality: { greater_than_or_equal_to: 900 }, timeslot: true
    validates :start_time, timeslot: true

    delegate :round_to_timeslot, to: :class
  end

  class_methods do
    # time: nil, Time, DateTime, String, Numeric
    def round_to_timeslot(time:)
      return nil if time.to_s.empty?
      [time.to_i / 900 * 900, 0].max
    end
  end
end
