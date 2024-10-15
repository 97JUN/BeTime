//
//  MainTabBarController.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
  private let userWeatherFactory = AppDIContainer.shared.getUserWeatherViewFactory()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setTabBar()
  }

  private func setTabBar() {
    let userWeatherViewController = userWeatherFactory.create()
    let cityListViewController = CityListViewController()
    let cityListNavigationController = UINavigationController(rootViewController: cityListViewController)

    userWeatherViewController.tabBarItem = UITabBarItem(
      title: "MyWeather",
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person.fill")
    )

    cityListNavigationController.tabBarItem = UITabBarItem(
      title: "CityList",
      image: UIImage(systemName: "list.bullet"),
      selectedImage: UIImage(systemName: "list.bullet")
    )

    self.viewControllers = [
      userWeatherViewController,
      cityListNavigationController,
    ]

    let appearance = UITabBarAppearance().then {
      $0.backgroundColor = .backgroundColor
    }
    
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
  }
}
