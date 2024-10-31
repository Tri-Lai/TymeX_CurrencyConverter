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
        let urlString = "https://api.exchangeratesapi.io/v1/latest?access_key=c6fffaed5cfc927a5aaad56bc316c2c6"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        // Fetch data from API
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for HTTP error 403: Missing parameters
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: Check the API key and parameters."
                }
                return
            }

            // Mapping JSON to Currency model
            let currencyResponse = try JSONDecoder().decode(CurrencyResponse.self, from: data)
            
            // Check both 'from' and 'to' currencies exist
            guard let fromRate = currencyResponse.rates[from],
                  let toRate = currencyResponse.rates[to] else {
                DispatchQueue.main.async {
                    self.errorMessage = "Currency not supported."
                }
                return
            }
            
            // Calculate the converted amount
            let convertedAmount = amount * toRate / fromRate;
            
            DispatchQueue.main.async {
                self.conversionResult = convertedAmount
                self.errorMessage = nil
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An error occurred: \(error.localizedDescription)"
            }
        }
    }
}
