//
//  SceneDelegate.swift
//  BeTime
//
//  Created by 쭌이 on 9/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = CityListViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene이 시스템에 의해 종료될 때 호출됩니다.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene이 활성화될 때 호출됩니다.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Scene이 비활성화될 때 호출됩니다.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene이 포그라운드로 진입할 때 호출됩니다.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Scene이 백그라운드로 전환될 때 호출됩니다.
    }
}
