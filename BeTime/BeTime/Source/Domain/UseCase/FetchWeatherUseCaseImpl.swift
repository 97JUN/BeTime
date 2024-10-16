//
//  SearchWeatherUseCase.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

import RxSwift

protocol FetchWeatherUseCase: AnyObject {
  func execute(locationInfo: Location, dateInfo: DateTime, cityName: String) -> Single<[WeatherForecast]>
}

final class FetchWeatherUseCaseImpl: FetchWeatherUseCase {
  private let weatherDataRepository: WeatherDataRepositoryProtocol
  private let disPoseBag = DisposeBag()

  init(weatherRepository: WeatherDataRepositoryProtocol) {
    self.weatherDataRepository = weatherRepository
  }

  func execute(locationInfo: Location, dateInfo: DateTime, cityName: String) -> Single<[WeatherForecast]> {
    let requestDTO = WeatherRequestDTO(
      baseDate: dateInfo.date,
      baseTime: dateInfo.time,
      nx: locationInfo.nx,
      ny: locationInfo.ny)

    return Single<[WeatherForecast]>.create { [weak self] single in
      self?.weatherDataRepository.requestWeatherData(request: requestDTO)
        .subscribe(onSuccess: { forecasts in
          single(.success(forecasts))
        }, onFailure: { error in
          single(.failure(error))
        })
        .disposed(by: self?.disPoseBag ?? DisposeBag())

      return Disposables.create()
    }

  }
}
