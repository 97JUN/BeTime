//
//  UserWeatherViewFactory.swift
//  BeTime
//
//  Created by 쭌이 on 9/23/24.
//

import Foundation
import UIKit

import Swinject

protocol UserWeatherViewFactory {
  func create() -> UIViewController
}

struct UserWeatherViewDependency {
  let weatherDataRepository: WeatherDataRepositoryProtocol
}

final class UserWeatherViewFactoryImpl: UserWeatherViewFactory {
  private let userWeatherViewDependency: UserWeatherViewDependency

  init(dependency: UserWeatherViewDependency) {
    self.userWeatherViewDependency = dependency
  }

  func create() -> UIViewController {
    let userWeatherInteractor = UserWeatherInteractor(
      searchWeatherUseCase: FetchWeatherUseCaseImpl(
        weatherRepository: userWeatherViewDependency.weatherDataRepository
      )
    )
    let userWeatherViewController = UserWeatherViewController(interactor: userWeatherInteractor)
    userWeatherInteractor.delegate = userWeatherViewController
    return userWeatherViewController
  }
}
