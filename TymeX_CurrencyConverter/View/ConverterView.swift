import SwiftUI


struct CurrencyConverterView: View {
    @State private var fromCurrency: String = "EUR"
    @State private var toCurrency: String = "USD"
    @State private var amount: String = "1000.00"
    @State private var convertedAmount: String = "736.70"
    @State private var exchangeRate: String = "0.7367"
    @StateObject private var viewModel = CurrencyConverterViewModel()
    
    // List all currencies for picker
    let currencies: [String] = [
        "DZD", "AOA", "BWP", "EGP", "KES", "MAD", "NGN", "ZAR", "SDG", "TZS", "UGX", "AFN", "AMD", "AZN", "BHD", "BDT", "CNY", "INR", "IDR", "IRR", "ILS", "JPY", "JOD", "KZT", "KRW", "KWD", "MYR", "OMR", "PKR", "QAR", "SAR", "SGD", "SYP", "THB", "TMT", "AED", "VND", "ALL", "EUR", "GBP", "BGN", "HRK", "CZK", "DKK", "HUF", "ISK", "NOK", "PLN", "RON", "RUB", "RSD", "CHF", "UAH", "CAD", "CRC", "CUP", "DOP", "HNL", "MXN", "NIO", "USD", "AUD", "FJD", "NZD", "PGK", "WST", "AUD", "TOP", "ARS", "BRL", "CLP", "COP", "USD", "PYG", "PEN", "SRD", "UYU", "VES","BTC", "ETH", "XRP", "LTC", "ADA", "BNB", "SOL"
    ]

    var body: some View {
        
        // Whole page layout
        VStack(spacing: 20) {
            Text("Currency Converter")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Check live rates, set rate alerts, receive notifications and more.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                // Input Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        // Currency Picker
                        Picker("From Currency", selection: $viewModel.fromCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: viewModel.fromCurrency) { _ in
                            viewModel.convertCurrency()
                        }
                        
                        Spacer()
                        
                        // Amount TextField
                        TextField("Amount", text: $viewModel.amount)
                            .keyboardType(.decimalPad)
                            .frame(width: 100, height: 40)
                            .multilineTextAlignment(.center)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: viewModel.amount) { _ in
                                viewModel.convertCurrency()
                            }
                    } // HStack: Amount section
                } // VStack: Input box
                
                Divider().padding(.horizontal)
                
                // Converted Amount Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Converted Amount")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        // Currency Picker
                        Picker("To Currency", selection: $toCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: viewModel.toCurrency) { _ in
                            viewModel.convertCurrency()
                        }
                        
                        Spacer()
                        
                        // Converted Amount Text
                        Text(viewModel.convertedAmount)
                            .frame(width: 100, height: 40)
                            .multilineTextAlignment(.center)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    } // HStack: Output section
                } // VStack: Converted output box
            } // VStack: Converter box
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            
            // Exchange Rate estimation
            VStack(spacing: 5) {
                Text("Indicative Exchange Rate")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Text("1 \(viewModel.fromCurrency) = \(viewModel.exchangeRate) \(viewModel.toCurrency)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            } // VStack: Exchange rate estimation layout
            
            Spacer()
        } // VStack: Whole view layout
        .padding()
        .background(Color("background"))
    }
}

struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
    }
}
