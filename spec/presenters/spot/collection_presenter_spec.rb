# frozen_string_literal: true
RSpec.describe Spot::CollectionPresenter do
  subject(:presenter) { described_class.new(solr_doc, ability, nil) }

  let(:solr_doc) { SolrDocument.new(metadata) }
  let(:ability) { Ability.new(user) }
  let(:metadata) { core_metadata }
  let(:core_metadata) do
    {
      id: 'abc123',
      title_tesim: ['Cool Collection'],
      read_access_group_ssim: ['public']
    }
  end
  let(:admin_user) { create(:admin_user) }
  let(:plain_user) { create(:user) }
  let(:user) { plain_user }

  describe '#collection_featurable?' do
    subject { presenter.collection_featurable? }

    context 'when collection is public' do
      context 'when user is admin' do
        let(:user) { admin_user }

        it { is_expected.to be true }
      end

      context 'when a regular user' do
        let(:user) { plain_user }

        it { is_expected.to be false }
      end
    end

    context 'when a collection is not public' do
      let(:metadata) { core_metadata.merge(read_access_group_ssim: ['private']) }

      let(:user) { admin_user }

      it { is_expected.to be false }
    end
  end

  describe '#display_feature_link?' do
    subject { presenter.display_feature_link? }

    let(:user) { admin_user }

    context do
      before { FeaturedCollection.destroy_all }

      it { is_expected.to be true }
    end

    context 'when a collection can\'t be featured' do
      let(:user) { plain_user }

      it { is_expected.to be false }
    end

    context 'when FeaturedCollections are at their max' do
      before { allow(FeaturedCollection).to receive(:can_create_another?).and_return(false) }

      it { is_expected.to be false }
    end

    context 'when a collection is already featured' do
      before { FeaturedCollection.create(collection_id: 'abc123') }

      it { is_expected.to be false }
    end
  end

  describe '#display_unfeature_link?' do
    subject { presenter.display_unfeature_link? }

    let(:user) { admin_user }

    context do
      before { FeaturedCollection.create(collection_id: 'abc123') }

      it { is_expected.to be true }
    end

    context 'when a collection isn\'t already featured' do
      before { FeaturedCollection.destroy_all }

      it { is_expected.to be false }
    end

    context 'when a collection isn\'t featurable' do
      let(:metadata) { core_metadata.merge(read_access_group_ssim: ['private']) }

      it { is_expected.to be false }
    end
  end
end
