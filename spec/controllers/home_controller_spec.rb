require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "get index" do
    it "renders the index template" do
      get :index
      expect(controller).to render_template(:index)
    end

    it "sets the start date as today" do
      get :index
      expect(assigns(:start)).to eq(DateTime.current.beginning_of_day)
    end
  end
end
