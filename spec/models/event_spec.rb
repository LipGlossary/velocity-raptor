require 'rails_helper'
require 'shared_examples/timeslotted'

RSpec.describe Event, type: :model do
  it_behaves_like "Timeslotted"

  describe "validations" do
    it { should validate_presence_of(:period) }
    it { should validate_numericality_of(:period).is_greater_than_or_equal_to(0) }
    it { should allow_values(nil, "", 0).for(:scheduled_time) }
    it { should validate_presence_of(:title) }
    it { should allow_value("foo").for(:title) }
    it { should_not allow_value("", " ").for(:title) }
  end
end
