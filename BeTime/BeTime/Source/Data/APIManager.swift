//
//  APIManager.swift
//  BeTime
//
//  Created by 쭌이 on 9/2/24.
//

import Alamofire
import Foundation

final class APIManager {
  static let shared = APIManager()

  func request<T: Decodable>(with url: String, parameters: [String: String], completion: @escaping (Result<T, Error>) -> Void) {
    AF.request(url, parameters: parameters)
      .validate()
      .responseData { response in
        switch response.result {
        case .success(let data):
          do {
            let decodeData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodeData))
          } catch {
            print("Decoding error: \(error)")
            completion(.failure(error))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
}
