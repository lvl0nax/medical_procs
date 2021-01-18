require 'rails_helper'

RSpec.describe MedicalProcedure do
  describe '.ilike_with_order' do
    subject { described_class.ilike_with_order(query) }

    let(:query) { 'therapy' }
    let!(:procedure0) { create(:medical_procedure, title: 'Simple Medical Procedure') }
    let!(:procedure1) { create(:medical_procedure, title: 'Simple therapy') }
    let!(:procedure2) { create(:medical_procedure, title: 'Therapy') }
    let!(:procedure3) { create(:medical_procedure, title: 'Therapy Extra') }
    let!(:procedure4) { create(:medical_procedure, title: 'Some therapy') }

    it 'returns sorted records for search query' do
      is_expected.to eq [procedure2, procedure3, procedure4, procedure1]
    end

    context 'when there is no a search query' do
      let(:query) { '' }

      it 'returns all records from the DB' do
        expect(subject.size).to eq(5)
      end
    end
  end
end
