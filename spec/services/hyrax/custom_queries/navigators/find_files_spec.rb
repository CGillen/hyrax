RSpec.describe Hyrax::CustomQueries::Navigators::FindFiles do
  let(:query_service) { Valkyrie::MetadataAdapter.find(:test_adapter).query_service }
  subject(:query_handler) { described_class.new(query_service: query_service) }

  describe '#find_files' do
    context 'when files exist' do
      let!(:file_metadata1) { FactoryBot.create_using_test_adapter(:hyrax_file_metadata) }
      let!(:file_metadata2) { FactoryBot.create_using_test_adapter(:hyrax_file_metadata) }
      let!(:fileset) { FactoryBot.create_using_test_adapter(:hyrax_file_set, files: [file_metadata1, file_metadata2]) }
      it 'returns file metadata resource' do
        expect(query_handler.find_files(file_set: fileset).map(&:id).map(&:to_s)).to match_array [file_metadata1.id.to_s, file_metadata2.id.to_s]
      end
    end

    context 'when files do not exist' do
      let!(:fileset) { FactoryBot.build(:hyrax_file_set) }
      it 'returns an empty array' do
        expect(query_handler.find_files(file_set: fileset)).to be_empty
      end
    end
  end

  describe '#find_original_file' do
    context 'when original file exists' do
      let!(:original_file) { FactoryBot.create_using_test_adapter(:hyrax_file_metadata) }
      let!(:fileset) { FactoryBot.create_using_test_adapter(:hyrax_file_set, files: [original_file], original_file: original_file) }
      it 'returns file metadata resource' do
        expect(query_handler.find_original_file(file_set: fileset).id.to_s).to eq original_file.id.to_s
      end
    end

    context 'when files do not exist' do
      let!(:fileset) { FactoryBot.build(:hyrax_file_set) }
      it 'raises error' do
        expect { query_handler.find_original_file(file_set: fileset) }
          .to raise_error ::Valkyrie::Persistence::ObjectNotFoundError, "File set's original file is blank"
      end
    end

    context 'when file_set does not respond to original file' do
      let!(:fileset) { FactoryBot.build(:hyrax_resource) }
      it 'raises error' do
        expect { query_handler.find_original_file(file_set: fileset) }
          .to raise_error ::Valkyrie::Persistence::ObjectNotFoundError, "Hyrax::Resource is not a `Hydra::FileSet` implementer"
      end
    end
  end

  describe '#find_extracted_text' do
    context 'when extracted text exists' do
      let!(:extracted_text) { FactoryBot.create_using_test_adapter(:hyrax_file_metadata) }
      let!(:fileset) { FactoryBot.create_using_test_adapter(:hyrax_file_set, files: [extracted_text], extracted_text: extracted_text) }
      it 'returns file metadata resource' do
        expect(query_handler.find_extracted_text(file_set: fileset).id.to_s).to eq extracted_text.id.to_s
      end
    end

    context 'when files do not exist' do
      let!(:fileset) { FactoryBot.build(:hyrax_file_set) }
      it 'raises error' do
        expect { query_handler.find_extracted_text(file_set: fileset) }
          .to raise_error ::Valkyrie::Persistence::ObjectNotFoundError, "File set's extracted text is blank"
      end
    end

    context 'when file_set does not respond to extracted text' do
      let!(:fileset) { FactoryBot.build(:hyrax_resource) }
      it 'raises error' do
        expect { query_handler.find_extracted_text(file_set: fileset) }
          .to raise_error ::Valkyrie::Persistence::ObjectNotFoundError, "Hyrax::Resource is not a `Hydra::FileSet` implementer"
      end
    end
  end

  describe '#find_thumbnail' do
    context 'when thumbnail exists' do
      let!(:thumbnail) { FactoryBot.create_using_test_adapter(:hyrax_file_metadata) }
      let!(:fileset) { FactoryBot.create_using_test_adapter(:hyrax_file_set, files: [thumbnail], thumbnail: thumbnail) }
      it 'returns file metadata resource' do
        expect(query_handler.find_thumbnail(file_set: fileset).id.to_s).to eq thumbnail.id.to_s
      end
    end

    context 'when files do not exist' do
      let!(:fileset) { FactoryBot.build(:hyrax_file_set) }
      it 'raises error' do
        expect { query_handler.find_thumbnail(file_set: fileset) }
          .to raise_error ::Valkyrie::Persistence::ObjectNotFoundError, "File set's thumbnail is blank"
      end
    end

    context 'when file_set does not respond to thumbnail' do
      let!(:fileset) { FactoryBot.build(:hyrax_resource) }
      it 'raises error' do
        expect { query_handler.find_thumbnail(file_set: fileset) }
          .to raise_error ::Valkyrie::Persistence::ObjectNotFoundError, "Hyrax::Resource is not a `Hydra::FileSet` implementer"
      end
    end
  end
end
