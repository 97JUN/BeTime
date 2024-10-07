//
//  CityDetailViewController.swift
//  BeTime
//
//  Created by 쭌이 on 10/6/24.
//

import Foundation
import UIKit

final class CityDetailViewController: UIViewController {
  private let contentView = CityDetailContentView()
  private let interactor: CityDetailInteractor

  init(interactor: CityDetailInteractor, userLocation: UserLocation) {
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
    interactor.viewDidLoad(userLocation: userLocation)
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
  }
}

extension CityDetailViewController: CityDetailInteractorDelegate {
  func didUpdateWeatherData(_ viewModel: CityDetailViewModel) {
    self.contentView.configure(viewModel: viewModel)
  }
}
