//
//  UserWeatherViewController.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import UIKit

final class UserWeatherViewController: UIViewController {
   var viewModel: UserWeatherViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
  }
}
