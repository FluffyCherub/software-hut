require 'rails_helper'

RSpec.describe "Feedbacks", type: :request do

  describe "GET /feedback_matrix" do
    it "returns http success" do
      get "/feedback/feedback_matrix"
      expect(response).to have_http_status(:success)
    end
  end

end
