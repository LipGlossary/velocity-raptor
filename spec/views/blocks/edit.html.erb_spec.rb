require 'rails_helper'

RSpec.describe "blocks/edit", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :type => "",
      :duration => "",
      :event => nil,
      :title => "MyString"
    ))
  end

  it "renders the edit block form" do
    render

    assert_select "form[action=?][method=?]", block_path(@block), "post" do

      assert_select "input#block_type[name=?]", "block[type]"

      assert_select "input#block_duration[name=?]", "block[duration]"

      assert_select "input#block_event_id[name=?]", "block[event_id]"

      assert_select "input#block_title[name=?]", "block[title]"
    end
  end
end
