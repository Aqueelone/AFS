require 'rails_helper'

RSpec.describe DashboardsController, :type => :controller do

  describe "GET Dashboards" do
    it "returns http success" do
      get :Dashboards
      expect(response).to be_success
    end
  end

end
