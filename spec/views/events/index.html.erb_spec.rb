require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, 2.times.map do
      Event.create!(
        :period => 1800,
        :duration => 900,
        :title => "Title"
      )
    end)
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => 1800.to_s, :count => 2
    assert_select "tr>td", :text => 900.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
