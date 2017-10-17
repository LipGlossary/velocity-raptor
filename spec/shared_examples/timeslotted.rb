require "rails_helper"

shared_examples_for "Timeslotted" do
  describe "delegations" do
    it { should delegate_method(:round_to_timeslot).to(:class) }
  end

  timeslots = {
    acceptable: {
      inputs: [15.minutes, 30.minutes, 1.day, "900"],
      outputs: [900, 1800, 86400, 900],
    },
    unacceptable: {
      inputs: [1, -1, -900, 16.minutes, "1", "15.minutes"],
      outputs: [0, 0, 0, 900, 0, 0],
    },
  }

  shared_context "timeslot" do |attr_name, allow_nil: false, min: 0|
    if allow_nil
      it "does not allow a value of ''" do
        obj = described_class.new(attr_name => "")
        obj.valid?

        expect(obj[attr_name]).to eq nil
        expect(obj.errors.include?(attr_name)).to eq false
      end
    else
      it "does not allow a value of nil" do
        obj = described_class.new(attr_name => nil)
        obj.valid?

        expect(obj[attr_name]).to eq min
        expect(obj.errors.include?(attr_name)).to eq false
      end

      it "does not allow a value of ''" do
        obj = described_class.new(attr_name => "")
        obj.valid?

        expect(obj[attr_name]).to eq min
        expect(obj.errors.include?(attr_name)).to eq false
      end
    end

    if min > 0
      it "does not allow a value less than #{min}" do
        obj = described_class.new(attr_name => min)
        obj.valid?
        expect(obj[attr_name]).to eq min
        expect(obj.errors.include?(attr_name)).to eq false

        obj = described_class.new(attr_name => min.to_i - 1)
        obj.valid?
        expect(obj[attr_name]).to eq min
        expect(obj.errors.include?(attr_name)).to eq false
      end
    end

    it "gets sensible values from setting sensible values" do
      timeslots[:acceptable][:inputs].each.with_index do |input, index|
        obj = described_class.new(attr_name => input)
        expect(obj[attr_name]).to eq timeslots[:acceptable][:outputs][index]
      end
    end

    it "gets sensible values from setting insensible values" do
      timeslots[:unacceptable][:inputs].each.with_index do |input, index|
        obj = described_class.new(attr_name => input)
        expect(obj[attr_name]).to eq [timeslots[:unacceptable][:outputs][index], min].max
      end
    end
  end
end
