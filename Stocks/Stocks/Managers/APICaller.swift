//
//  APICaller.swift
//  Stocks
//
//  Created by Elizeu RS on 05/11/22.
//

import Foundation

final class APICaller {
  static let shared = APICaller()
  
  private struct Constants {
    static let apiKey = "cdkip12ad3idmsqf0t5gcdkip12ad3idmsqf0t60"
    static let sandboxApiKey = "" // removed(?)
    static let baseUrl = "https://finnhub.io/api/v1/"
    static let day: TimeInterval = 3600 * 24
  }
  
  private init() {}
  
  // MARK: - Public
  
  //  get stock info
  
  //  search stocks
//  public func search(query: String, completion: @escaping(Result<[String], Error>) -> Void) {
  public func search(
    query: String,
    completion: @escaping(Result<SearchResponse, Error>) -> Void
  ) {
//    guard let url = url(
//      for: .search,
//      queryParams: ["q":query]
//    ) else {
//      return
//    }
    
    // accounting for spaces or any character that's invalid for a query.
    guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return
    }
    
    request(
      url: url(
        for: .search,
        queryParams: ["q": safeQuery]
      ),
      expecting: SearchResponse.self,
      completion: completion
    )
  }
  
  public func news(
    for type: NewsViewController.`Type`,
    completion: @escaping (Result<[NewsStory], Error>) -> Void
  ) {
    switch type {
      // endpoint: /news?category=general
      // endpoint: /news?category=forex&minId=10
    case .topStories:
      request(url: url(for: .topStories, queryParams: ["category": "general"]),
              expecting: [NewsStory].self,
              completion: completion
      )
      // endpoint: /company-news?symbol=AAPL&from=2021-09-01&to=2021-09-09
    case .company(let symbol):
      let today = Date()
      let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
      request(
        url: url(
          for: .companyNews,
          queryParams: [
            "symbol":symbol,
            "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
            "to": DateFormatter.newsDateFormatter.string(from: today)
                       ]
        ),
        expecting: [NewsStory].self,
        completion: completion
      )
    }
  }
  
//https://finnhub.io/api/v1/stock/candle?symbol=AAPL&resolution=1&from=1631022248&to=1631627048&token=cdkip12ad3idmsqf0t5gcdkip12ad3idmsqf0t60
  public func marketData(
    for symbol: String,
    numberOfDays: TimeInterval = 7,
    completion: @escaping (Result<MarketDataResponse, Error>) -> Void
  ) {
    let today = Date().addingTimeInterval(-(Constants.day))
    let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
    request(
      url: url(
        for: .marketData,
        queryParams: [
          "symbol": symbol,
          "resolution": "1",
          "from": "\(Int(prior.timeIntervalSince1970))",
          "to": "\(Int(today.timeIntervalSince1970))"
        ]
      ),
      expecting: MarketDataResponse.self,
      completion: completion
    )
  }
  
  public func financialMetrics(
    for symbol: String,
    completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void
  ) {
    request(
      url: url(
        for: .financials,
        queryParams: ["symbol": symbol, "metric": "all"]
                    ),
      expecting: FinancialMetricsResponse.self,
      completion: completion
    )
  }
  
  // MARK: - Private
  
  private enum Endpoint: String {
    case search
    case topStories = "news"
    case companyNews = "company-news"
    case marketData = "stock/candle"
    case financials = "stock/metric"
//    https://finnhub.io/api/v1/stock/candle?symbol=AAPL&resolution=1&from=1631022248&to=1631627048&token=cdkip12ad3idmsqf0t5gcdkip12ad3idmsqf0t60
  }
  
  private enum APIError: Error {
    case noDataReturned
    case invalidUrl
  }
  
  private func url(
    for endpoint: Endpoint,
    queryParams: [String: String] = [:]
  ) -> URL? {
    var urlString = Constants.baseUrl + endpoint.rawValue
    
    var queryItems = [URLQueryItem]()
    // Add any parameters
    for(name, value) in queryParams {
      queryItems.append(.init(name: name, value: value))
    }
    
    // Add token
    queryItems.append(.init(name: "token", value: Constants.apiKey))
    
    // Convert query items to suffix string
    urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
//    print("\n\(urlString)\n")
    return URL(string: urlString)
  }
  
  // codable - convert json into object
  private func request<T: Codable>(
    url: URL?,
    expecting: T.Type,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    guard let url = url else {
      // Invalid url
      completion(.failure(APIError.invalidUrl))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.failure(APIError.noDataReturned))
        }
        return
      }
      
      do {
        let result = try JSONDecoder().decode(expecting, from: data)
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
    }
    
    // this kicks off your task
    task.resume()
  }
}
