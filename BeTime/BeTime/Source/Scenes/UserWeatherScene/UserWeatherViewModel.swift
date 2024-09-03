//
//  UserWeatherViewModel.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

final class UserWeatherViewModel {
  private let fetchWeatherUseCase: FetchWeatherUseCase

  private var skyConditionDatas: [WeatherForecast]?
  private var temperatureDatas: [WeatherForecast]?
  private var percipitationDatas: [WeatherForecast]?

  init(searchWeatherUseCase: FetchWeatherUseCase) {
    self.fetchWeatherUseCase = searchWeatherUseCase
  }

  func viewDidLoad() {
    self.checkLocationAuth()
  }

  func getUserLcoation() -> Location {
    // Location Core에서 위,경도 값 구한다음 격자값으로 변환
    let location = Location(nx: "100", ny: "100") // 임시데이터
    return location
  }

  func getUserDate() -> DateTime {
  private func checkLocationAuth() {
    let status = LocationCore.shared.checkAuthorizationStatus()

    switch status {
    case .notDetermined:
      // 사용자에게 권한 요청을 보낸다
      LocationCore.shared.requestLocationAuthorization()
    case .restricted, .denied:
      // 시스템 설정에서 설정값을 요청하도록 UIAlertController생성
      break
    case .authorizedAlways:
      // 날씨 데이터 요청 하도록
    case .authorizedWhenInUse:
      // 백그라운드에서 사용할 필요 x
      break
    @unknown default:
      break
    }
  }
    let time = DateTime.getDateTime()
    return time
  }

  func fetchWeather() {
    self.fetchWeatherUseCase.execute(
      locationInfo: getUserLcoation(),
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
