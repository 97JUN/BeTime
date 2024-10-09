//
//  SearchWeatherUseCase.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

import RxSwift

protocol FetchWeatherUseCase: AnyObject {
  var delegate: FetchWeatherUseCaseDelegate? { get set }
  func execute(locationInfo: Location, dateInfo: DateTime, cityName: String)
}

protocol FetchWeatherUseCaseDelegate: AnyObject {
  func didUpdateForecastDatas(_ weatherForcasts: [WeatherForecast], cityName: String)
}

final class FetchWeatherUseCaseImpl: FetchWeatherUseCase {
  private let weatherDataRepository: WeatherDataRepositoryProtocol
  weak var delegate: FetchWeatherUseCaseDelegate?
  private let disPoseBag = DisposeBag()

  init(weatherRepository: WeatherDataRepositoryProtocol) {
    self.weatherDataRepository = weatherRepository
  }

  func execute(locationInfo: Location, dateInfo: DateTime, cityName: String) {
    let requestDTO = WeatherRequestDTO(
      baseDate: dateInfo.date,
      baseTime: dateInfo.time,
      nx: locationInfo.nx,
      ny: locationInfo.ny)
    return weatherDataRepository.requestWeatherData(request: requestDTO)
      .subscribe { [weak self] forecasts in
        self?.delegate?.didUpdateForecastDatas(forecasts, cityName: cityName)
      } onFailure: { error in
        print("weatherData update Error: \(error)")
      }.disposed(by: disPoseBag)
  }
}
