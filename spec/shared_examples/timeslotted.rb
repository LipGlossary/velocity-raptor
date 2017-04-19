require "rails_helper"

shared_examples_for "Timeslotted" do
  describe "validations" do
    valid_timeslots = [15.minutes, 30.minutes, 1.day, "900"]
    # invalid_timeslots = [1, -1, -900, 16.minutes, "1", "15.minutes"]

    # it { should validate_presence_of(:duration) }
    # it { should validate_numericality_of(:duration).is_greater_than_or_equal_to(15.minutes) }
    # it { should_not allow_values(*invalid_timeslots).for(:duration) }
    # it { should_not allow_values(0, "").for(:duration) }
    # it { should validate_numericality_of(:start_time).is_greater_than_or_equal_to(0) }
    # it { should_not allow_values(*invalid_timeslots).for(:start_time) }

    it { should allow_values(*valid_timeslots).for(:duration) }
    # TODO: Something more like timestamps for these...
    it { should allow_values(*valid_timeslots).for(:start_time) }
  end

  describe "delegations" do
    it { should delegate_method(:round_to_timeslot).to(:class) }
  end

  describe "attributes" do
    describe "set duration"
    describe "set start_time"
  end
end
