require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :period => 2,
      :duration => 900,
      :title => "Title",
      :scheduled_time => nil,
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/900/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/unscheduled/)
  end
end
