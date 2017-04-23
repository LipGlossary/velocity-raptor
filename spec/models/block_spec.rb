require 'rails_helper'
require 'shared_examples/timeslotted'

RSpec.describe Block, type: :model do
  it_behaves_like "Timeslotted"

  include_context "Timeslotted" do
    it_behaves_like "timeslot", :duration, min: 900
    it_behaves_like "timeslot", :start_time
  end

  describe "table" do
    # it { should have_db_column(:type).of_type(:string) }
    # it { should have_db_index(:type) }
    it { should have_db_column(:duration).of_type(:integer) }
    it { should have_db_column(:event_id).of_type(:integer) }
    it { should have_db_column(:start_time).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_index(:event_id) }
  end

  describe "associations" do
    it { should belong_to(:event) }
  end

  describe "validations" do
    it { should allow_values(nil, "foo").for(:title) }
    it { should_not allow_value("").for(:title) }
  end

  describe "attributes" do
    describe "get duration"
    describe "get title"
  end

  describe "before_save" do
    describe ".clean_event_fields"
  end
end
