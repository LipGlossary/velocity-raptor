require 'rails_helper'

RSpec.describe Event, type: :model do
  fdescribe "validations" do
    valid_timeslots = [15.minutes, 30.minutes, 1.day, "900"]
    invalid_timeslots = [1, -1, -15.minutes, 16.minutes, "1", "15.minutes"]

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:period) }
    it { should validate_numericality_of(:duration).is_greater_than_or_equal_to(15.minutes) }
    it { should validate_numericality_of(:period).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:scheduled_time).is_greater_than_or_equal_to(0) }
    it { should allow_value("foo").for(:title) }
    it { should_not allow_value("", " ").for(:title) }
    it { should allow_values(*valid_timeslots).for(:duration) }
    it { should_not allow_values(*invalid_timeslots).for(:duration) }
    it { should_not allow_values(0, "").for(:duration) }
    # TODO: Something more like timestamps for these...
    it { should allow_values(nil, 0, "").for(:scheduled_time) }
    it { should allow_values(*valid_timeslots).for(:scheduled_time) }
    it { should_not allow_values(*invalid_timeslots).for(:scheduled_time) }
  end
end
