//
//  CityDetailViewFactory.swift
//  BeTime
//
//  Created by 쭌이 on 10/7/24.
//

import Foundation
import UIKit

import Swinject

protocol CityDetailViewFactory {
  func create(userLocation: UserLocation) -> UIViewController
}

struct CityDetailViewDependency {
  let weatherDataRepository: WeatherDataRepositoryProtocol
}

final class CityDetailViewFactoryImpl: CityDetailViewFactory {
  private let cityDetailViewDependency: CityDetailViewDependency

  init(cityDetailViewDependency: CityDetailViewDependency) {
    self.cityDetailViewDependency = cityDetailViewDependency
  }

  func create(userLocation: UserLocation) -> UIViewController {
    let cityDetailInteractor = CityDetailInteractor(
      fetchWeatherUseCase: FetchWeatherUseCaseImpl(
        weatherRepository: cityDetailViewDependency.weatherDataRepository
      )
    )
    let cityDetailViewController = CityDetailViewController(
      interactor: cityDetailInteractor,
      userLocation: userLocation
    )

    cityDetailInteractor.delegate = cityDetailViewController
    return cityDetailViewController
  }
}
