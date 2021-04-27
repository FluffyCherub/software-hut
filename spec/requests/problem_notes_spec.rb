 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/problem_notes", type: :request do
  # ProblemNote. As you add validations to ProblemNote, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ProblemNote.create! valid_attributes
      get problem_notes_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      problem_note = ProblemNote.create! valid_attributes
      get problem_note_url(problem_note)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_problem_note_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      problem_note = ProblemNote.create! valid_attributes
      get edit_problem_note_url(problem_note)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ProblemNote" do
        expect {
          post problem_notes_url, params: { problem_note: valid_attributes }
        }.to change(ProblemNote, :count).by(1)
      end

      it "redirects to the created problem_note" do
        post problem_notes_url, params: { problem_note: valid_attributes }
        expect(response).to redirect_to(problem_note_url(ProblemNote.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ProblemNote" do
        expect {
          post problem_notes_url, params: { problem_note: invalid_attributes }
        }.to change(ProblemNote, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post problem_notes_url, params: { problem_note: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested problem_note" do
        problem_note = ProblemNote.create! valid_attributes
        patch problem_note_url(problem_note), params: { problem_note: new_attributes }
        problem_note.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the problem_note" do
        problem_note = ProblemNote.create! valid_attributes
        patch problem_note_url(problem_note), params: { problem_note: new_attributes }
        problem_note.reload
        expect(response).to redirect_to(problem_note_url(problem_note))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        problem_note = ProblemNote.create! valid_attributes
        patch problem_note_url(problem_note), params: { problem_note: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested problem_note" do
      problem_note = ProblemNote.create! valid_attributes
      expect {
        delete problem_note_url(problem_note)
      }.to change(ProblemNote, :count).by(-1)
    end

    it "redirects to the problem_notes list" do
      problem_note = ProblemNote.create! valid_attributes
      delete problem_note_url(problem_note)
      expect(response).to redirect_to(problem_notes_url)
    end
  end
end
