require 'rails_helper'

RSpec.describe Api::V1::MedicalProceduresController do
  describe 'GET #index' do
    subject { get :index, params: { query: query } }

    let(:query) { 'therapy' }
    let!(:procedure0) { create(:medical_procedure, title: 'Simple Medical Procedure') }
    let!(:procedure1) { create(:medical_procedure, title: 'Therapy') }
    let!(:procedure2) { create(:medical_procedure, title: 'Therapy Extra') }

    it 'returns json with sorted title of procedures' do
      subject
      expect(response.body).to eq ['Therapy', 'Therapy Extra'].to_json
    end

    context 'when procedure titles do not contain the query' do
      let(:query) { 'test' }

      it 'returns empty json array' do
        subject
        expect(response.body).to eq [].to_json
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { title: title } }

    let(:title) { 'title' }

    it 'creates a new medical procedure' do
      expect { subject }.to change(MedicalProcedure, :count).by(1)
    end

    context 'when there is a medical procedure with the same name' do
      let(:title) { 'Medical Procedure' }
      let!(:procedure0) { create(:medical_procedure, title: title) }

      it 'returns 400 status' do
        subject
        expect(response.status).to eq(400)
      end
    end
  end
end
