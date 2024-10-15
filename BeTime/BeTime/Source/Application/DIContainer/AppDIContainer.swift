//
//  UserWeatherDIContainer.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import Foundation
import Swinject

final class AppDIContainer {
  static let shared = AppDIContainer()
  let container: Container

  private init() {
    container = Container()

    container.register(WeatherDataRepository.self) { _ in
      WeatherDataRepository()
    }.inObjectScope(.container)

    container.register(FetchWeatherUseCase.self) { resolver in
      FetchWeatherUseCaseImpl(weatherRepository: resolver.resolve(WeatherDataRepository.self)!)
    }.inObjectScope(.container)

    container.register(UserWeatherViewFactory.self) { resolver in
      let fetchWeatherUseCase = resolver.resolve(FetchWeatherUseCase.self)!
      let dependency = UserWeatherViewDependency(
        userWeatherInteractor: UserWeatherInteractor(
          searchWeatherUseCase: fetchWeatherUseCase
        )
      )
      return UserWeatherViewFactoryImpl(dependency: dependency)
    }.inObjectScope(.container)
  }

  func getUserWeatherViewFactory() -> UserWeatherViewFactory {
    return container.resolve(UserWeatherViewFactory.self)!
  }
}
