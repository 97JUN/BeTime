//
//  SearchWeatherUseCase.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation
import RxSwift

protocol FetchWeatherUseCase {
  func execute(locationInfo: Location, dateInfo: DateTime) -> Single<[WeatherForecast]>
}

final class FetchWeatherUseCaseImpl: FetchWeatherUseCase {
  private let weatherDataRepository: WeatherDataRepositoryProtocol

  init(weatherRepository: WeatherDataRepositoryProtocol) {
    self.weatherDataRepository = weatherRepository
  }

  func execute(locationInfo: Location, dateInfo: DateTime) -> Single<[WeatherForecast]> {
    let requestDTO = WeatherRequestDTO(
      baseDate: dateInfo.date,
      baseTime: dateInfo.time,
      nx: locationInfo.nx,
      ny: locationInfo.ny)
    return weatherDataRepository.requestWeatherData(request: requestDTO)
      .map { response in
        let responses: [WeatherForecast] = response
        return responses
      }
  }
}
