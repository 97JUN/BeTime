//
//  MainTabBarController.swift
//  BeTime
//
//  Created by 쭌이 on 9/10/24.
//

import UIKit

class MainTabBarController: UITabBarController {
  var userWeatherSceneDIContainer: UserWeatherSceneDIContainer!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setTabBar()
  }

  private func setTabBar() {
    userWeatherSceneDIContainer = UserWeatherSceneDIContainer()
    let userWeatherViewController = userWeatherSceneDIContainer.resolveUserWeatherViewController()

    let firstViewController = UINavigationController(rootViewController: userWeatherViewController)
    firstViewController.tabBarItem = UITabBarItem(title: "MyWeather", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

    let secondViewController = UINavigationController(rootViewController: CityListViewController())
    secondViewController.tabBarItem = UITabBarItem(title: "CityList", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet"))

    self.viewControllers = [firstViewController, secondViewController]
    self.tabBar.backgroundColor = .lightGray
  }
}
