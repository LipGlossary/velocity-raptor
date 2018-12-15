require 'rails_helper'

RSpec.describe "blocks/index", type: :view do
  before(:each) do
    assign(:blocks, [
      Block.create!(
        :type => nil,
        :duration => "",
        :event => nil,
        :title => "Title",
        :start_time => Time.current,
      ),
      Block.create!(
        :type => nil,
        :duration => "",
        :event => nil,
        :title => "Title",
        :start_time => Time.current,
      )
    ])
  end

  it "renders a list of blocks" do
    render
    assert_select "tr>td", :text => "FreeBlock".to_s, :count => 2
    assert_select "tr>td", :text => 900.to_s, :count => 2
    assert_select "tr>td", :text => "none".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
