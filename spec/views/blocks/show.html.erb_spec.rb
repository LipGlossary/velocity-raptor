require 'rails_helper'

RSpec.describe "blocks/show", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :type => "Type",
      :duration => "",
      :event => nil,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
  end
end
