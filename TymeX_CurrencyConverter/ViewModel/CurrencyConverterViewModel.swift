import Foundation
import Combine

class CurrencyConverterViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var fromCurrency: String = "EUR"
    @Published var toCurrency: String = "USD"
    @Published var amount: String = "1000.00"
    @Published var convertedAmount: String = ""
    @Published var exchangeRate: String = ""

    private var cancellable: AnyCancellable?

    // Function to convert currency with corresponding amount
    func convertCurrency() {
        
        guard let amountValue = Double(amount) else {
            convertedAmount = "Invalid amount"
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

//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            // Check for HTTP error 403: Missing parameters
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error: Check the API key and parameters."
//                }
//                return
//            }
//
//            // Mapping JSON to Currency model
//            let currencyResponse = try JSONDecoder().decode(CurrencyResponse.self, from: data)
//            
//            // Check both 'from' and 'to' currencies exist
//            guard let fromRate = currencyResponse.rates[from],
//                  let toRate = currencyResponse.rates[to] else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Currency not supported."
//                }
//                return
//            }
//            
//            // Calculate the converted amount
//            let convertedAmount = amount * toRate / fromRate;
//            
//            DispatchQueue.main.async {
//                self.conversionResult = convertedAmount
//                self.errorMessage = nil
//            }
            
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CurrencyResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error fetching exchange rate: \(error)"
                    }
                }
            }, receiveValue: { [weak self] response in
                self?.updateConversion(response: response, amount: amountValue)
            })
            
        
    }
    
    private func updateConversion(response: CurrencyResponse, amount: Double) {
        if let fromRate = response.rates[fromCurrency],
           let toRate = response.rates[toCurrency] {
            let rate = toRate / fromRate
            self.exchangeRate = String(format: "%.4f", rate)
            self.convertedAmount = String(format: "%.2f", amount * rate)
        } else {
            self.convertedAmount = "Conversion error"
        }
    }
}
