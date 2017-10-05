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

    delegate :round_to_timeslot, to: :class
  end

  class_methods do
    # time: nil, Time, DateTime, String, Numeric
    def round_to_timeslot(time:, allow_nil: false, min: 0)
      return nil if allow_nil && time.to_s.empty?
      [time.to_i / 900 * 900, min].max
    end

    def acts_as_timeslot (attr_name, allow_nil: false, min: 0)
      attr_str = attr_name.to_s

      define_method attr_str do
        self.read_attribute attr_str
      end

      define_method "#{attr_str}=" do |val|
        if val.is_a?(Hash)
          val = DateTime.new(*val.values.compact)
        end
        self.write_attribute attr_str, round_to_timeslot(time: val, allow_nil: allow_nil, min: min)
      end

      validates attr_name,
        presence: !allow_nil,
        allow_nil: allow_nil,
        numericality: { greater_than_or_equal_to: min },
        timeslot: true
    end
  end

  private

  def hash_to_time(hash: {})
    args = %w(year month day hour minute).map { |key| hash[key] }.take_while(&:present?)

    Time.new(*args) if args.any?
  end
end
