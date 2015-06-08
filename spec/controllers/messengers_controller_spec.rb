require 'rails_helper'

RSpec.describe MessengersController, :type => :controller do

  describe "GET Messengers" do
    it "returns http success" do
      get :Messengers
      expect(response).to be_success
    end
  end

end
