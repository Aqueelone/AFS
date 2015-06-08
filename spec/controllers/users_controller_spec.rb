require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET Users" do
    it "returns http success" do
      get :Users
      expect(response).to be_success
    end
  end

end
