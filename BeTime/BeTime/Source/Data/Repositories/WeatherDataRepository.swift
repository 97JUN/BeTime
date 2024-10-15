//
//  WeatherRepository.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation
import RxSwift

final class WeatherDataRepository: WeatherDataRepositoryProtocol {
  private let url = APIConfig.baseURL
  func requestWeatherData(request: WeatherRequestDTO) -> Single<[WeatherForecast]> {
    let parameters = request.parameters()

    return APIManager.shared
      .request(with: url, parameter: parameters)
      .map { (result: WeatherResponseDTO<WeatherItem>) -> [WeatherForecast] in
        return result.response.body.items.item
          .map { $0.toDomain() }
          .filter { $0.category != .unknown }
      }
  }
}
