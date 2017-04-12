require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "user_utc_offset" do
    it "should return UTC when no offset is given"
    it "should return Pacific when 480 is given"
  end
end
