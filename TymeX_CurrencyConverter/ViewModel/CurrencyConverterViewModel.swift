import Foundation

class CurrencyConverterViewModel: ObservableObject {
    @Published var conversionResult: Double?
    @Published var errorMessage: String?
    
    
    // Function to convert currency with corresponding amount
    func convertCurrency(from: String, to: String, amount: Double) async {
        
        // Check if amount valid
        guard amount > 0 else {
            self.errorMessage = "Amount must be greater than zero."
            return
        }

        // Define URL
        let urlString = """
            https://api.exchangeratesapi.io/v1/convert
            ? access_key = 6b9cf7a61408100da41eaec41faba924
            & from = \(from)
            & to = \(to)
            & amount = \(amount)
        """
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        // Fetch data from provider's API
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Mapping response to data model
            let response = try JSONDecoder().decode(CurrencyResponse.self, from: data)
            
            if response.success {
                DispatchQueue.main.async {
                    self.conversionResult = response.result
                    self.errorMessage = nil
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Conversion failed. Please try again."
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An error occurred: \(error.localizedDescription)"
            }
        }
    }
}

