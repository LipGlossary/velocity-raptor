require 'rails_helper'
require 'shared_examples/timeslotted'

RSpec.describe Event, type: :model do
  it_behaves_like "Timeslotted"

  include_context "Timeslotted" do
    it_behaves_like "timeslot", :duration, :relative, min: 900
    it_behaves_like "timeslot", :period, :relative, allow_nil: true
    it_behaves_like "timeslot", :scheduled_time, allow_nil: true
  end

  describe "table" do
    it { should have_db_column(:duration).of_type(:integer).with_options(default: 900, null: false) }
    it { should have_db_column(:period).of_type(:integer) }
    it { should have_db_column(:scheduled_time).of_type(:integer) }
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
  end

  describe "associatons" do
    it { should have_many(:blocks).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should allow_value("foo").for(:title) }
    it { should_not allow_value("", " ").for(:title) }

    it "has a period greater than or equal to the event's duration" do
      instance = described_class.new(duration: 1.day)
      instance.valid?
      expect(instance.errors[:period]).to be_blank

      instance.period = instance.duration
      instance.valid?
      expect(instance.errors[:period]).to be_blank

      instance.period = instance.duration - 1.minute
      expect(instance).to_not be_valid
      expect(instance.errors[:period]).to_not be_blank
    end
  end

  describe "attributes" do
    describe "get start_times"
  end

  describe "callbacks" do
    describe "#unschedule_blocks" do
      let(:time) { Time.now }
      let(:event) { Event.create!(title: "Foo", scheduled_time: time, period: 1.year) }

      it "destroys all blocks" do
        expect { event.send(:unschedule_blocks) }.to change { event.blocks.count }.from(5).to(0)
      end

      describe "after_destroy" do
        it "destroys all blocks when event is destroyed" do
          event
          expect { event.destroy }.to change { Block.count }.from(5).to(0)
        end
      end
    end

    describe "#schedule_blocks" do
      describe "when event is unscheduled" do
        it "schedules no blocks when period is nil" do
          event = Event.create!(title: "Foo")
          Block.destroy_all
          expect { event.send(:schedule_blocks) }.to_not change { event.blocks.count }.from(0)
        end

        it "schedules no blocks when period is not nil" do
          event = Event.create!(title: "Foo", period: 1.year)
          Block.destroy_all
          expect { event.send(:schedule_blocks) }.to_not change { event.blocks.count }.from(0)
        end
      end

      describe "when event is scheduled" do
        it "schedules one block when period is nil" do
          event = Event.create!(title: "Foo", scheduled_time: Time.now)
          Block.destroy_all
          expect { event.send(:schedule_blocks) }.to change { event.blocks.count }.from(0).to(1)
        end

        it "schedules a block each step between scheduled_time and system max when period is not nil" do
          event = Event.create!(title: "Foo", scheduled_time: Time.now, period: 1.year)
          Block.destroy_all
          expect { event.send(:schedule_blocks) }.to change { event.blocks.count }.from(0).to(5)
        end
      end
    end

    describe "#reschedule_blocks" do
      let(:time) { Time.now }
      let(:event) { Event.create!(title: "Foo", scheduled_time: time, period: 1.year) }

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

        it "reschedules all blocks when the period changes" do
          expect(event).to receive(:reschedule_blocks).once
          event.update!(period: 2.years)
        end
      end
    end
  end
end
