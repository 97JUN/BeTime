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
  let userWeatherInteractor: UserWeatherInteractor
}

final class UserWeatherViewFactoryImpl: UserWeatherViewFactory {
  private let userWeatherViewDependency: UserWeatherViewDependency

  init(dependency: UserWeatherViewDependency) {
    self.userWeatherViewDependency = dependency
  }

  func create() -> UIViewController {
    let userWeatherInteractor = userWeatherViewDependency.userWeatherInteractor
    let userWeatherViewController = UserWeatherViewController(interactor: userWeatherInteractor)
    return userWeatherViewController
  }
}
