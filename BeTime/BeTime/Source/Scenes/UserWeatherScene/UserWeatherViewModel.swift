//
//  UserWeatherViewModel.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

final class UserWeatherViewModel {
  private let fetchWeatherUseCase: FetchWeatherUseCaseProtocol

  private var skyConditionDatas: [WeatherForecast]?
  private var temperatureDatas: [WeatherForecast]?
  private var percipitationDatas: [WeatherForecast]?

  init(searchWeatherUseCase: FetchWeatherUseCaseProtocol) {
    self.fetchWeatherUseCase = searchWeatherUseCase
  }

  func viewDidLoad() {
    self.fetchWeather()
  }

  func getUserLcoation() -> Location {
    // Location Core에서 위,경도 값 구한다음 격자값으로 변환
    let location = Location(nx: "100", ny: "100") // 임시데이터
    return location
  }

  func getUserDate() -> DateTime {
    let time = DateTime.getDateTime()
    return time
  }

  func fetchWeather() {
    self.fetchWeatherUseCase.execute(locationInfo: getUserLcoation(),
                                     dateInfo: getUserDate()
    ) { [weak self] result in
      switch result {
      case .success(let forcastData):
        self?.updateWeatherdata(with: forcastData)
      case .failure(let failure):
        print("load fail: \(failure)")
      }
    }
  }

  private func updateWeatherdata(with data: [WeatherForecast]) {
    skyConditionDatas = data.filter { $0.category == .skyCondition }
    temperatureDatas = data.filter { $0.category == .temperature }
    percipitationDatas = data.filter { $0.category == .precipitation }
  }
}
