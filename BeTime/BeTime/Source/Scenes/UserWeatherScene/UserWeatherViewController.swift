//
//  UserWeatherViewController.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//
import UIKit

import PinLayout
import RxSwift

final class UserWeatherViewController: UIViewController {
  private let contentView = UserWeatherContentView()
  var interactor: UserWeatherInteractor
  private let disposeBag = DisposeBag()

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

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.delegate = self
    interactor.viewDidLoad()
  }
}

extension UserWeatherViewController: UserWeatherInteractorDelegate {
  func didUpdateWeatherData(_ viewModel: UserWeatherViewModel) {
    self.contentView.configure(viewModel: viewModel)
  }

}
