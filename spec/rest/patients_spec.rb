require 'spec_helper'
require 'vandelay/rest/patients'

RSpec.describe Vandelay::REST::PatientsPatient do
  describe '#get all patients' do
    it 'returns single patient json' do
      get '/patients'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to be_an(Array)
    end
  end
end

