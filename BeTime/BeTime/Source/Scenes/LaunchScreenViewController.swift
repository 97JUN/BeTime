//
//  LaunchScreenViewController.swift
//  BeTime
//
//  Created by 쭌이 on 9/13/24.
//

import PinLayout
import Then
import UIKit

final class LaunchScreenViewController: UIViewController {
  private let launchScreenImageView = UIImageView().then {
    $0.image = UIImage(named: "lauchScreen.beTime")
    $0.contentMode = .scaleAspectFit
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .beTimeBackgroundColor
    view.addSubview(launchScreenImageView)

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
      guard let firstWindow = firstScene.windows.first else { return }
      firstWindow.rootViewController = MainTabBarController()
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    launchScreenImageView.pin
      .center().size(250)
  }
}
