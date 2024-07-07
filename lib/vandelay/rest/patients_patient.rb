require 'vandelay/services/patients'
require 'vandelay/services/patient_records'
module Vandelay
  module REST
    module PatientsPatient
      def self.service
        @patient_by_id ||= Vandelay::Services::Patients.new
      end

      def self.registered(app) #uses the already defined method to retrieve patient record
        app.get '/patients/:patient_id' do
          result = Vandelay::REST::PatientsPatient.service.retrieve_one(params[:patient_id])
          return json(status: 200, message: 'No Record Found!') if result.nil?
          json(result.attributes)
        end

        app.get '/patients/:patient_id/record' do
          result = Vandelay::Services::PatientRecords.new.retrieve_record_for_patient(params[:patient_id])
          return json(status: 200, message: 'No Record Found!') if result.empty?
          json(result)
        end
      end
    end
  end
end
