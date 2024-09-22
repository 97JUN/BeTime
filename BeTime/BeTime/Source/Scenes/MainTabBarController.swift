//
//  MainTabBarController.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
  var userWeatherSceneDIContainer: UserWeatherSceneDIContainer!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setTabBar()
  }

  private func setTabBar() {
    userWeatherSceneDIContainer = UserWeatherSceneDIContainer()
    let userWeatherViewController = userWeatherSceneDIContainer.resolveUserWeatherViewController()
    let cityListViewController = CityListViewController()

    userWeatherViewController.tabBarItem = UITabBarItem(
      title: "MyWeather",
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person.fill")
    )

    cityListViewController.tabBarItem = UITabBarItem(
      title: "CityList",
      image: UIImage(systemName: "list.bullet"),
      selectedImage: UIImage(systemName: "list.bullet")
    )

    self.viewControllers = [
      userWeatherViewController,
      cityListViewController,
    ]

    let appearance = UITabBarAppearance().then {
      $0.backgroundColor = .beTimeBackgroundColor
    }
    
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
  }
}
