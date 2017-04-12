require 'rails_helper'

RSpec.describe "blocks/index", type: :view do
  before(:each) do
    assign(:blocks, [
      Block.create!(
        :type => "Type",
        :duration => "",
        :event => nil,
        :title => "Title"
      ),
      Block.create!(
        :type => "Type",
        :duration => "",
        :event => nil,
        :title => "Title"
      )
    ])
  end

  it "renders a list of blocks" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
