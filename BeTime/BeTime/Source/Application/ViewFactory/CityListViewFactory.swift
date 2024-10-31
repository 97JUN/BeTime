//
//  CityListViewFactory.swift
//  BeTime
//
//  Created by 쭌이 on 10/31/24.
//

import Foundation
import UIKit

protocol CityListViewFactory {
  func create() -> UIViewController
}

struct CityListViewDependency {

}

final class CityListviFactoryImpl: CityListViewFactory {
  private let cityListViewDependency: CityListViewDependency

  init(cityListViewDependency: CityListViewDependency) {
    self.cityListViewDependency = cityListViewDependency
  }

  func create() -> UIViewController {
    return CityListViewController()
  }
}
