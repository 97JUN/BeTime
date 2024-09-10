//
//  UserWeatherSceneDIContainer.swift
//  BeTime
//
//  Created by 쭌이 on 9/10/24.
//

import Foundation
import Swinject
import UIKit

class UserWeatherSceneDIContainer {
  let container: Container

  init() {
    container = Container()

    container.register(WeatherDataRepository.self) { _ in
      WeatherDataRepository()
    }

    container.register(FetchWeatherUseCase.self) { resolver in
      FetchWeatherUseCaseImpl(weatherRepository: resolver.resolve(WeatherDataRepository.self)!)
    }

    container.register(UserWeatherInteractor.self) { resolver in
      UserWeatherInteractor(searchWeatherUseCase: resolver.resolve(FetchWeatherUseCase.self)!)
    }

    container.register(UserWeatherViewController.self) { resolver in
      let viewController = UserWeatherViewController()
      viewController.interactor = resolver.resolve(UserWeatherInteractor.self)
      return viewController
    }
  }

  func resolveUserWeatherViewController() -> UserWeatherViewController {
    return container.resolve(UserWeatherViewController.self)!
  }
}
