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

  describe "callbacks" do
    describe "#unschedule_blocks" do
      let(:time) { Time.now }
      let(:event) { Event.create!(title: "Foo", scheduled_time: time, period: 0) }

      it "destroys all blocks" do
        expect { event.send(:unschedule_blocks) }.to change { event.blocks.count }.from(1).to(0)
      end

      describe "after_destroy" do
        it "destroys all blocks when event is destroyed" do
          event
          expect { event.destroy }.to change { Block.count }.from(1).to(0)
        end
      end
    end

    describe "#schedule_blocks" do
      it "schedules no blocks when event is unscheduled" do
        event = Event.create!(title: "Foo", period: 0)
        Block.destroy_all
        expect { event.send(:schedule_blocks) }.to_not change { event.blocks.count }.from(0)
      end

      it "schedules one block when event is scheduled" do
        event = Event.create!(title: "Foo", scheduled_time: Time.now, period: 0)
        Block.destroy_all
        expect { event.send(:schedule_blocks) }.to change { event.blocks.count }.from(0).to(1)
      end
    end

    describe "#reschedule_blocks" do
      let(:time) { Time.now }
      let(:event) { Event.create!(title: "Foo", scheduled_time: time, period: 0) }

      it "unschedules all blocks" do
        expect(event).to receive(:unschedule_blocks).once
        event.send(:reschedule_blocks)
      end

      it "schedules all blocks" do
        expect(event).to receive(:schedule_blocks).once
        event.send(:reschedule_blocks)
      end

      describe "after_save" do
        it "reschedules all blocks when the scheduled time changes" do
          expect(event).to receive(:reschedule_blocks).once
          event.update!(scheduled_time: time + 1.day)
        end
      end
    end
  end
end
