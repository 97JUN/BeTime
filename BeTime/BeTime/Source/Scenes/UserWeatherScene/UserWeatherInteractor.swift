//
//  UserWeatherInteractor.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation
import RxSwift

struct UserWeatherViewModel {
  let skyConditionDatas: [WeatherForecast]
  let temperatureDatas: [WeatherForecast]
  let percipitationDatas: [WeatherForecast]
  let cityName: String
}

final class UserWeatherInteractor {
  private let fetchWeatherUseCase: FetchWeatherUseCase
  private var cityName: String?
  
  private let disposeBag = DisposeBag()
  let userWeatherViewModelSubject = BehaviorSubject<UserWeatherViewModel?>(value: nil)

  init(searchWeatherUseCase: FetchWeatherUseCase) {
    self.fetchWeatherUseCase = searchWeatherUseCase
  }

  func viewDidLoad() {
    self.checkLocationAuth()
  }

  // MARK: - Location Method

  private func fetchUserLocation() {
    LocationCore.shared.fetchUserLocation { [weak self] userLocation in
      if let userLocation = userLocation {
        self?.cityName = userLocation.cityName
        self?.convertLocationData(userLocation)
      } else {
        print("fail Retry") // 실패시 어떻게? 빈데이터?
      }
    }
  }

  private func convertLocationData(_ userLocation: UserLocation) {
    self.cityName = userLocation.cityName
    let location = userLocation.convertToGRID(
      lat: userLocation.latitude,
      lng: userLocation.longitude
    )
    self.fetchWeatherData(for: location, on: self.getUserDate())
  }

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
      self.fetchUserLocation()
    case .authorizedWhenInUse:
      // 백그라운드에서 사용할 필요 x
      break
    @unknown default:
      break
    }
  }

  // MARK: - Date Method

  private func getUserDate() -> DateTime {
    let time = DateTime.getDateTime()
    return time
  }

  // MARK: - WeatherData Method

  private func fetchWeatherData(for location: Location, on date: DateTime) {
    self.fetchWeatherUseCase.execute(locationInfo: location, dateInfo: date)
      .subscribe { [weak self] forecastData in
        self?.updateWeatherdata(with: forecastData)
      } onFailure: { error in
        print("Load error: \(error)")
      }
      .disposed(by: disposeBag)
  }

  private func updateWeatherdata(with data: [WeatherForecast]) {
    let viewModel = UserWeatherViewModel(
      skyConditionDatas: data.filter { $0.category == .skyCondition },
      temperatureDatas: data.filter { $0.category == .temperature },
      percipitationDatas: data.filter { $0.category == .precipitation },
      cityName: self.cityName ?? "알수 없음"
    )
    userWeatherViewModelSubject.onNext(viewModel)
  }
}
