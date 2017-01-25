describe Hyrax::My::CollectionsController, type: :controller do
  describe "logged in user" do
    let(:user)  { create(:user) }
    let(:other) { create(:user) }

    let!(:my_file)              { create(:work, user: user) }
    let!(:first_collection)     { create(:public_collection, user: user) }
    let!(:unrelated_collection) { create(:public_collection, user: other) }

    before { sign_in user }

    describe "#index" do
      context "with mulitple pages of collections" do
        before { 2.times { create(:public_collection, user: user) } }
        it "paginates" do
          get :index, params: { per_page: 2 }
          expect(assigns[:document_list].length).to eq 2
          get :index, params: { per_page: 2, page: 2 }
          expect(assigns[:document_list].length).to be >= 1
        end
      end

      it "shows only collections that I own" do
        get :index
        expect(response).to be_successful
        expect(assigns[:document_list].map(&:id)).to contain_exactly(first_collection.id)
      end
    end

    describe "#search_facet_path" do
      subject { controller.send(:search_facet_path, id: 'keyword_sim') }
      it { is_expected.to eq "/dashboard/collections/facet/keyword_sim?locale=en" }
    end
  end
end
