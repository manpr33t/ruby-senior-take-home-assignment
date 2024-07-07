require 'vandelay/integrations/base'
module Vandelay
  module Integrations
    class FetchVendors < Vandelay::Integrations::Base

      def fetch_data(patient_id, vendor_id, server_number)
        data = server_number == '' ? {} : self.fetch_api(vendor_id, server_number)
        {
          "patient_id": patient_id,
          "province": data["province"] || data["province_code"] || '',
          "allergies": data["allergies"] || data["allergies_list"] || [],
          "num_medical_visits": data["recent_medical_visits"] || data['medical_visits_recently'] || ''
        }
      end
    end
  end
end
