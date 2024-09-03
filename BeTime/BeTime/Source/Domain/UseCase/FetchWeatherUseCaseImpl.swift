//
//  SearchWeatherUseCase.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

protocol FetchWeatherUseCase {
  func execute(locationInfo: Location,
               dateInfo: DateTime,
               completion: @escaping (Result<[WeatherForecast], Error>) -> Void
  )
}

final class FetchWeatherUseCaseImpl: FetchWeatherUseCase {
  private let weatherDataRepository: WeatherDataRepositoryProtocol

  init(weatherRepository: WeatherDataRepositoryProtocol) {
    self.weatherDataRepository = weatherRepository
  }

  func execute(locationInfo: Location,
               dateInfo: DateTime,
               completion: @escaping (Result<[WeatherForecast], Error>) -> Void)
  {
    let requestDTO = WeatherRequestDTO(
      baseDate: dateInfo.date,
      baseTime: dateInfo.time,
      nx: locationInfo.nx,
      ny: locationInfo.ny
    )

    weatherDataRepository.fetchWeatherData(request: requestDTO) { result in
      switch result {
      case .success(let response):
        let forecasts: [WeatherForecast] = response
          .map { $0.toDomain() }
          .filter { $0.category != .unknown }
        completion(.success(forecasts))

      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
