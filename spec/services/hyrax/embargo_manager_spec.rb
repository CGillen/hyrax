# frozen_string_literal: true

RSpec.describe Hyrax::EmbargoManager do
  subject(:manager) { described_class.new(resource: resource) }
  let(:resource)    { Hyrax::Resource.new }

  shared_context 'when under embargo' do
    let(:resource) { FactoryBot.build(:hyrax_resource, :under_embargo) }
  end

  shared_context 'with expired embargo' do
    let(:resource) { FactoryBot.build(:hyrax_resource, embargo: embargo) }
    let(:embargo)  { FactoryBot.build(:hyrax_embargo, :expired) }
  end

  describe '#apply' do
    context 'with no embargo' do
      it 'is a no-op' do
        expect { manager.apply }
          .not_to change { resource.visibility }
      end
    end

    context 'with expried embargo' do
      include_context 'with expired embargo'

      it 'is a no-op' do
        expect { manager.apply }
          .not_to change { resource.visibility }
      end
    end

    context 'when under embargo' do
      include_context 'when under embargo'

      before { resource.visibility = 'open' }

      it 'applies the active embargo visibility' do
        expect { manager.apply }
          .to change { resource.visibility }
          .to 'authenticated'
      end
    end
  end

  describe '#copy_embargo_to' do
    let(:other_resource) { Hyrax::Resource.new }

    it 'does not assign an embargo when none is present' do
      expect { manager.copy_embargo_to(target: other_resource) }
        .not_to change { other_resource.embargo }
        .from nil
    end

    context 'with expried embargo' do
      include_context 'with expired embargo'

      it 'does not copy the embargo' do
        expect { manager.copy_embargo_to(target: other_resource) }
          .not_to change { other_resource.embargo }
          .from nil
      end
    end

    context 'when under embargo' do
      include_context 'when under embargo'

      before { other_resource.visibility = 'open' }

      it 'copies the embargo to the target' do
        expect { manager.copy_embargo_to(target: other_resource) }
          .to change { other_resource.embargo }
          .from(nil)
          .to have_attributes(embargo_release_date:
                                manager.embargo.embargo_release_date)
      end

      it 'applies the active embargo visibility' do
        expect { manager.copy_embargo_to(target: other_resource) }
          .to change { other_resource.visibility }
          .to 'authenticated'
      end
    end
  end

  describe '#embargo' do
    it 'gives an inactive embargo' do
      expect(manager.embargo).not_to be_active
    end

    context 'when under embargo' do
      include_context 'when under embargo'

      it 'gives an active embargo' do
        expect(manager.embargo).to be_active
      end

      it 'has embargo attributes' do
        expect(manager.embargo)
          .to have_attributes visibility_after_embargo: 'open',
                              visibility_during_embargo: 'authenticated',
                              embargo_release_date: an_instance_of(Date),
                              embargo_history: be_empty
      end
    end
  end

  describe '#under_embargo?' do
    it { is_expected.not_to be_under_embargo }

    context 'when under embargo' do
      include_context 'when under embargo'

      it { is_expected.to be_under_embargo }
    end

    context 'with expired embargo' do
      include_context 'with expired embargo'

      it { is_expected.not_to be_under_embargo }
    end
  end
end
