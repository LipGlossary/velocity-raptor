require 'rails_helper'

RSpec.describe "blocks/new", type: :view do
  before(:each) do
    assign(:block, Block.new(
      :type => "",
      :duration => "",
      :event => nil,
      :title => "MyString"
    ))
  end

  it "renders new block form" do
    render

    assert_select "form[action=?][method=?]", blocks_path, "post" do

      assert_select "input#block_type[name=?]", "block[type]"

      assert_select "input#block_duration[name=?]", "block[duration]"

      assert_select "input#block_event_id[name=?]", "block[event_id]"

      assert_select "input#block_title[name=?]", "block[title]"
    end
  end
end
