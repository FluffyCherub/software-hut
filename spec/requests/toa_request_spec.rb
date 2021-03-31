require 'rails_helper'

RSpec.describe "Toas", type: :request do

  describe "GET /toa_doc" do
    it "returns http success" do
      get "/toa/toa_doc"
      expect(response).to have_http_status(:success)
    end
  end

end
