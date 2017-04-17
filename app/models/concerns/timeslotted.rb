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

    validates :duration, presence: true, numericality: { greater_than_or_equal_to: 900 }, timeslot: true
    validates :start_time, timeslot: true
  end

  class_methods do
  end
end
