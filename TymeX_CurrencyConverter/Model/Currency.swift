import Foundation

struct CurrencyResponse: Codable {
    let success: Bool
    let query: Query
    let info: Info
    let historical: String?
    let date: String
    let result: Double
}

struct Query: Codable {
    let from: String
    let to: String
    let amount: Double
}

struct Info: Codable {
    let timestamp: Int
    let rate: Double
}
