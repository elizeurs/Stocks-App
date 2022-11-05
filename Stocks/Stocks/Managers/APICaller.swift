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
    static let apiKey = ""
    static let sandboxApiKey = ""
    static let baseUrl = "" 
  }
  
  private init() {}
  
  // MARK: - Public
  
  //  get stock info
  
  //  search stocks
  
  // MARK: - Private
  
  private enum Endpoint: String {
    case search
  }
  
  private enum APIError: Error {
    case noDataReturned
    case invalidUrl
  }
  
  private func url(
    for endpoint: Endpoint,
    queryParams: [String: String] = [:]
  ) -> URL? {
    
    return nil
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
