//
//  SearchWeatherUseCase.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

protocol FetchWeatherUseCaseProtocol {
  func execute(locationInfo: Location, dateInfo: DateTime, completion: @escaping (Result<[WeatherForecast], Error>) -> Void)
}

final class FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
  private let weatherRepository: WeatherDataRepositoryProtocol

  init(weatherRepository: WeatherDataRepositoryProtocol) {
    self.weatherRepository = weatherRepository
  }

  func execute(locationInfo: Location, dateInfo: DateTime, completion: @escaping (Result<[WeatherForecast], Error>) -> Void) {
    let requestDTO = WeatherRequestDTO(baseDate: dateInfo.date, baseTime: dateInfo.time, nx: locationInfo.nx, ny: locationInfo.ny)
    weatherRepository.requestWeatherData(with: requestDTO) { result in
      switch result {
      case .success(let response):
        let forecasts: [WeatherForecast] = response.map { $0.toDomain() }
        completion(.success(forecasts))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
