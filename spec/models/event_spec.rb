require 'rails_helper'
require 'shared_examples/timeslotted'

RSpec.describe Event, type: :model do
  it_behaves_like "Timeslotted"

  include_context "Timeslotted" do
    it_behaves_like "timeslot", :duration, min: 900
    it_behaves_like "timeslot", :scheduled_time, allow_nil: true
  end

  describe "table" do
    it { should have_db_column(:duration).of_type(:integer).with_options(default: 900, null: false) }
    it { should have_db_column(:period).of_type(:integer).with_options(default: 0, null: false) }
    it { should have_db_column(:scheduled_time).of_type(:integer) }
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  end

  describe "associatons" do
    it { should have_many(:blocks).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:period) }
    it { should validate_numericality_of(:period).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:title) }
    it { should allow_value("foo").for(:title) }
    it { should_not allow_value("", " ").for(:title) }
  end

  describe "attributes" do
    describe "get start_times"
  end
end
