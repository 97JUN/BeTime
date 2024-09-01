//
//  UserWeatherViewModel.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

final class UserWeatherViewModel {
  private let fetchWeatherUseCase: FetchWeatherUseCaseProtocol
  private var forcastDatas: [WeatherForecast]?

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
    // DateCore에서 얻은 날짜, 시간
    let time = DateTime(date: "20240808", time: "1400") // 임시데이터
    return time
  }

  func fetchWeather() {
    self.fetchWeatherUseCase.execute(locationInfo: getUserLcoation(), dateInfo: getUserDate()) { [weak self] result in
      switch result {
      case .success(let forcastData):
        self?.forcastDatas?.append(contentsOf: forcastData)
      case .failure(let failure):
        print("load fail")
        // fail 시 처리
      }
    }
  }
}
