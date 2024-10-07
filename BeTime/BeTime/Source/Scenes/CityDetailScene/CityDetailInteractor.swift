//
//  CityDetailInteractor.swift
//  BeTime
//
//  Created by 쭌이 on 10/7/24.
//

import Foundation

protocol CityDetailInteractorDelegate: AnyObject {
  func didUpdateWeatherData(_ viewModel: CityDetailViewModel)
}

final class CityDetailInteractor {
  private let fetchWeatherUseCase: FetchWeatherUseCase
  weak var delegate: CityDetailInteractorDelegate?

  init(fetchWeatherUseCase: FetchWeatherUseCase) {
    self.fetchWeatherUseCase = fetchWeatherUseCase
  }

  func viewDidLoad(userLocation: UserLocation) {
    fetchWeatherUseCase.delegate = self
    self.convertLocationData(userLocation)
  }

  private func convertLocationData(_ userLocation: UserLocation) {
    let cityName = userLocation.cityName
    let location = userLocation.convertToGRID(
      lat: userLocation.latitude,
      lng: userLocation.longitude
    )
    self.fetchWeatherUseCase.execute(locationInfo: location,
                                     dateInfo: self.getUserDate(),
                                     cityName: cityName)
  }

  private func getUserDate() -> DateTime {
    let time = DateTime.getDateTime()
    return time
  }

  private func updateWeatherData(with data: [WeatherForecast], cityName: String) {
    let viewModel = CityDetailViewModel(
      skyConditionDatas: data.filter { $0.category == .skyCondition },
      temperatureDatas: data.filter { $0.category == .temperature },
      precipitationDatas: data.filter { $0.category == .precipitation },
      cityName: cityName
    )
    delegate?.didUpdateWeatherData(viewModel)
  }
}

extension CityDetailInteractor: FetchWeatherUseCaseDelegate {
  func didUpdateForecastDatas(_ weatherForcasts: [WeatherForecast], cityName: String) {
    self.updateWeatherData(with: weatherForcasts, cityName: cityName)
  }
}
