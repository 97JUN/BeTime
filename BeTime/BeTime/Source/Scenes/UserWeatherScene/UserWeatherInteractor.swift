//
//  UserWeatherInteractor.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation
import CoreLocation

import RxSwift

protocol UserWeatherInteractorDelegate: AnyObject {
  func didUpdateWeatherData(_ viewModel: UserWeatherViewModel)
  func deniedLocationAuth()
}

final class UserWeatherInteractor {
  private let fetchWeatherUseCase: FetchWeatherUseCase
  private let disposBag = DisposeBag()

  weak var delegate: UserWeatherInteractorDelegate?

  init(searchWeatherUseCase: FetchWeatherUseCase) {
    self.fetchWeatherUseCase = searchWeatherUseCase
  }

  func viewDidLoad() {
    self.checkLocationAuth()
    self.setDelegate()
  }

  private func setDelegate() {
    LocationCore.shared.delegate = self
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
      .subscribe { [weak self] weatherForcasts in
        self?.updateWeatherdata(with: weatherForcasts, cityName: cityName)
      } onFailure: { error in
        self.updateWeatherdata(
          with: [
            WeatherForecast(
              category: .temperature,
              time: "",
              value: ""
            )
          ],
          cityName: cityName
        )
      }.disposed(by: disposBag)
  }

  private func checkLocationAuth() {
    let status = LocationCore.shared.checkAuthorizationStatus()

    switch status {
    case .notDetermined:
      LocationCore.shared.requestLocationAuthorization()
    case .restricted, .denied:
      delegate?.deniedLocationAuth()
      break
    case .authorizedAlways:
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

extension UserWeatherInteractor: LocationAuthorizationDelegate {
  func authorizationDidChange(status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      self.fetchUserLocation()
    case .denied, .restricted:
      delegate?.deniedLocationAuth()
    case .notDetermined:
      break
    @unknown default:
      break
    }
  }
}
