//
//  UserWeatherViewController.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import RxSwift
import UIKit

final class UserWeatherViewController: UIViewController {
  var interactor: UserWeatherInteractor!
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.viewDidLoad()
    self.fetchViewModel()
  }

  private func fetchViewModel() {
    interactor.userWeatherViewModelSubject
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] viewModel in
        print("\(viewModel.cityName)")

      })
      .disposed(by: disposeBag)
  }
}
