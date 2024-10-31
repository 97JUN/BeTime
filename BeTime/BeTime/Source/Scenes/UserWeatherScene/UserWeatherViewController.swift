//
//  UserWeatherViewController.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//
import UIKit

final class UserWeatherViewController: UIViewController {
  private let contentView = UserWeatherContentView()
  private let interactor: UserWeatherInteractor

  init(interactor: UserWeatherInteractor) {
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = contentView
  }

  override func viewWillAppear(_ animated: Bool) {
    interactor.viewDidLoad()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.viewDidLoad()
  }

  private func presentAlert() {
    var alertModel = AlertModel(
      title: "위치 권한 요청",
      message: "위치 서비스 사용불가.\n 설정으로 이동하여 위치 권한을 수정해 주세요"
    )
    alertModel.okAction = {
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
      }
    }
    let alert = alertModel.createAlert()
    self.present(alert, animated: false)
  }
}

extension UserWeatherViewController: UserWeatherInteractorDelegate {
  func deniedLocationAuth() {
    DispatchQueue.main.async {
      self.presentAlert()
    }
  }
  
  func didUpdateWeatherData(_ viewModel: UserWeatherViewModel) {
    self.contentView.configure(viewModel: viewModel)
  }

}
