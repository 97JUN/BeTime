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

    container.register(UserWeatherViewFactory.self) { resolver in
      let dependency = UserWeatherViewDependency(
        weatherDataRepository: resolver.resolve(WeatherDataRepository.self)!
      )
      return UserWeatherViewFactoryImpl(dependency: dependency)
    }.inObjectScope(.container)

    container.register(CityListViewFactory.self) { resolver in
      let dependency = CityListViewDependency()
      return CityListviFactoryImpl(cityListViewDependency: dependency)
    }.inObjectScope(.container)

    container.register(CityDetailViewFactory.self) { resolver in
      let dependency = CityDetailViewDependency(
        weatherDataRepository: resolver.resolve(WeatherDataRepository.self)!
      )
      return CityDetailViewFactoryImpl(cityDetailViewDependency: dependency)
    }.inObjectScope(.container)
  }

  func getUserWeatherViewFactory() -> UserWeatherViewFactory {
    return container.resolve(UserWeatherViewFactory.self)!
  }

  func getCityListViewFactory() -> CityListViewFactory {
    return container.resolve(CityListViewFactory.self)!
  }

  func getCityDetailViewFactory() -> CityDetailViewFactory {
    return container.resolve(CityDetailViewFactory.self)!
  }
}
