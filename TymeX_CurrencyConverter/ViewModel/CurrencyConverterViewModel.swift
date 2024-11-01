import Foundation
import Combine

class CurrencyConverterViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var fromCurrency: String = "EUR"
    @Published var toCurrency: String = "USD"
    @Published var amount: String = "1000.00"
    @Published var convertedAmount: String = ""
    @Published var exchangeRate: String = ""
    
    // Alert variable
    @Published public var showAlert: Bool = false
    @Published public var alertMessage: String = ""

    private var cancellable: AnyCancellable?

    // FUNCTION: Validate input
    public func validateAmount(_ input: String) {        
        if let amountValue = Double(input) {
            if amountValue <= 0 {
                alertMessage = "Please enter a positive amount."
                showAlert = true
            }
        } else {
            alertMessage = "Invalid input. Please enter a valid number."
            showAlert = true
        }
    }
    
    // FUNCTION: Convert currency with corresponding amount
    func convertCurrency() {
        
        // Check invalid input at first
        guard let amountValue = Double(amount) else {
            convertedAmount = "Invalid"
            return
        }
        
        if amountValue <= 0 {
            DispatchQueue.main.async {
                self.errorMessage = "Amount should be greater than zero"
            }
            return
        }

        // Define URL
        let urlString = "https://api.exchangeratesapi.io/v1/latest?access_key=8b1d5a61852d943c6668b60dff3e4860"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        // Calling API for currency data
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
    
    // FUNCTION: Convert to desired currency with corresponding amount
    private func updateConversion(response: CurrencyResponse, amount: Double) {
        
        // Unwrapping currency rates and calculating currency
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
