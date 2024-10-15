//
//  APIManager.swift
//  BeTime
//
//  Created by 쭌이 on 9/2/24.
//

import Alamofire
import Foundation
import RxSwift

final class APIManager {
  static let shared = APIManager()

  func request<T: Decodable>(with url: String, parameter: [String: String]) -> Single<T> {
    return Single.create { single in
      AF.request(url, parameters: parameter)
        .validate()
        .responseData { response in
          switch response.result {
          case .success(let data):
            do {
              let decodeData = try JSONDecoder().decode(T.self, from: data)
              single(.success(decodeData))
            } catch let decodingError {
              print("Decoding error: \(decodingError)")
              single(.failure(decodingError))
            }
          case .failure(let error):
            single(.failure(error))
          }
        }
      return Disposables.create()
    }
  }
}
