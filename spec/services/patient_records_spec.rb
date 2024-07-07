require 'spec_helper'
require 'vandelay/services/patient_records'

RSpec.describe Vandelay::Services::PatientRecords do
  describe '#retrieve_record_for_patient' do
    let(:service) { described_class.new }

    context 'fetch data for patient id 2 using mock_api_one'  do
      let(:id) { 2 }
      let(:mock_auth_data) {
        {
        "id": "1",
        "token": "2342wedfw24423d2d=="
        }
      }
      let(:mock_record_for_api_one) {
        {
          "id": "743",
          "full_name": "Cosmo Kramer",
          "dob": "1987-03-18",
          "province": "QC",
          "allergies": [
            "work",
            "conformity",
            "paying taxes"
          ],
          "recent_medical_visits": 1
        }
      }
      before do
        # Mocked external api
        stub_request(:get, "http://mock_api_one:80/auth/1")
          .to_return(status: 200, body: mock_auth_data.to_json, headers: { 'Content-Type': 'application/json' })

        stub_request(:get, "http://mock_api_one:80/patients/743")
          .to_return(status: 200, body: mock_record_for_api_one.to_json, headers: { 'Content-Type': 'application/json' })
      end

      it 'returns data from api' do
        data = service.retrieve_record_for_patient(id)
        expect(data[:province]).to eq("QC")
        expect(data[:allergies]).to eq([ "work", "conformity", "paying taxes"])
        expect(data[:patient_id]).to eq(2)
      end
    end

    context 'when API returns data and vendor api two was used'  do
      let(:id) { 3 }
      let(:mock_auth_data) {
        {
        "id": "1",
        "token": "1232132wdw132131=="
        }
      }
      let(:mock_record_for_api_two) {
        {
          "id"=>"16",
          "name"=>"George Costanza",
          "birthdate"=>"1984-09-07",
          "province_code"=>"ON",
          "clinic_id"=>"7",
          "allergies_list"=>["hair", "mean people", "paying the bill"],
          "medical_visits_recently"=>17}
      }

      before do
        # Mocking the API call
        stub_request(:get, "http://mock_api_two:80/auth_tokens/1")
          .to_return(status: 200, body: mock_auth_data.to_json, headers: { 'Content-Type': 'application/json' })

        stub_request(:get, "http://mock_api_two:80/records/16")
          .to_return(status: 200, body: mock_record_for_api_two.to_json, headers: { 'Content-Type': 'application/json' })
      end

      it 'fetches data from the API' do
        data = service.retrieve_record_for_patient(id)
        expect(data[:province]).to eq("ON")
        expect(data[:allergies]).to eq(["hair", "mean people", "paying the bill"])
        expect(data[:patient_id]).to eq(3)
      end
    end

    context 'when incorrect id was called'  do
      let(:id) { 456 }

      it 'returns empty hash' do
      	data = service.retrieve_record_for_patient(id)
        expect(data).to eq({})
      end
    end

    context 'when id without a record_vendor was called'  do
      let(:id) { 1 }

      it 'returns data with only patient_id' do
      	data = service.retrieve_record_for_patient(id)
        expect(data[:patient_id]).to eq(1)
        expect(data[:province]).to eq("")
        expect(data[:allergies]).to eq([])
      end
    end
  end
end
