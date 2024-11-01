import Foundation


struct CurrencyResponse: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
}
