//
//  WeatherRepository.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

final class WeatherDataRepository: WeatherDataRepositoryProtocol {
  func fetchWeatherData(
    request: WeatherRequestDTO,
    completion: @escaping (Result<[WeatherItem], Error>) -> Void
  ) {
    let url = request.baseURL
    let parameters = request.parameters()

    APIManager.shared.request(
      with: url,
      parameters: parameters
    ) { (result: Result<WeatherResponseDTO<WeatherItem>, Error>) in
      switch result {
      case .success(let weatherResponse):
        let items = weatherResponse.response.body.items.item
        completion(.success(items))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
