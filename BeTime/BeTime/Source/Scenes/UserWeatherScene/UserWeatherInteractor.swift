//
//  UserWeatherInteractor.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

protocol UserWeatherInteractorDelegate: AnyObject {
  func didUpdateWeatherData(_ viewModel: UserWeatherViewModel)
}

final class UserWeatherInteractor {
  private let fetchWeatherUseCase: FetchWeatherUseCase

  weak var delegate: UserWeatherInteractorDelegate?

  init(searchWeatherUseCase: FetchWeatherUseCase) {
    self.fetchWeatherUseCase = searchWeatherUseCase
  }

  func viewDidLoad() {
    self.checkLocationAuth()
    fetchWeatherUseCase.delegate = self
  }

  private func fetchUserLocation() {
    LocationCore.shared.fetchUserLocation { [weak self] userLocation in
      if let userLocation = userLocation {
        self?.convertLocationData(userLocation)
      } else {
        print("fail Retry") // 실패시 어떻게? 빈데이터?
      }
    }
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
      self.fetchUserLocation()
      break
    @unknown default:
      break
    }
  }

  private func getUserDate() -> DateTime {
    let time = DateTime.getDateTime()
    return time
  }

  private func updateWeatherdata(with data: [WeatherForecast], cityName: String) {
    let viewModel = UserWeatherViewModel(
      skyConditionDatas: data.filter { $0.category == .skyCondition },
      temperatureDatas: data.filter { $0.category == .temperature },
      precipitationDatas: data.filter { $0.category == .precipitation },
      cityName: cityName
    )
    delegate?.didUpdateWeatherData(viewModel)
  }
}

extension UserWeatherInteractor: FetchWeatherUseCaseDelegate {
  func didUpdateForecastDatas(_ weatherForcasts: [WeatherForecast], cityName: String) {
    self.updateWeatherdata(with: weatherForcasts, cityName: cityName)
  }
}
