RSpec.describe 'hyrax/permissions/confirm.html.erb', type: :view do
  let(:curation_concern) { stub_model(GenericWork) }
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    allow(view).to receive(:curation_concern).and_return(curation_concern)
    render
  end

  it 'renders the confirmation page' do
    expect(page).to have_content("Apply changes to contents?")
  end
end
