require 'vandelay/integrations/fetch_vendors'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient_id) #use patient id
        patient = Vandelay::Models::Patient.with_id(patient_id) #fetches details of record from the db
        return {} if patient.nil? #returns empty hash if no records found which has been handled under route
        api_to_use_id = patient.records_vendor || ''
        vendor_id = patient.vendor_id
        result = Vandelay::Integrations::FetchVendors.new.fetch_data(patient_id, vendor_id, api_to_use_id) #uses integration from
      end
    end
  end
end
