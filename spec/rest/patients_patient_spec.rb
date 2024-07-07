require 'spec_helper'
require 'vandelay/rest/patients_patient'

RSpec.describe Vandelay::REST::PatientsPatient do
  describe '#get patient by id' do
    it 'returns single patient json' do
      get '/patients/1'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Hash)
    end
  end

  describe '#gets patient record when vendor record not available' do
    it 'returns single patient record json' do
      get '/patients/1/record'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['allergies']).to eq([])
      expect(JSON.parse(last_response.body)['patient_id']).to eq('1')
    end
  end

  describe '#get patient by invalid id' do
    it 'returns no record found' do
      get '/patients/132'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Hash)
      expect(JSON.parse(last_response.body)['message']).to eq('No Record Found!')
    end
  end

  describe '#get patient by id' do
    it 'returns single patient json' do
      get '/patients/asd'
      expect(last_response).not_to be_ok
    end
  end

  describe '#get record by id' do
    it 'returns all patients' do
      get '/patients/1/record'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Hash)
    end
  end

  describe '#get record by invalid id' do
    it 'returns no record found' do
      get '/patients/123/record'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Hash)
      expect(JSON.parse(last_response.body)['message']).to eq('No Record Found!')
    end
  end
end

