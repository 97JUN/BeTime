//
//  CityListViewController.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//
import UIKit

final class CityListViewController: UIViewController {
  private let contentView = CityListContentView()
  private let cityDetailViewFactory = AppDIContainer.shared.getCityDetailViewFactory()

  override func loadView() {
    self.view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.delegate = self
    let savedCities = UserLocationManager.shared.loadUserLocations()
    contentView.configure(viewModel: CityListViewModel(savedCities: savedCities))
  }
}

extension CityListViewController: CityListContentViewDelegate {
  func didSelectCity(city: UserLocation) {
    let cityDetailViewController = cityDetailViewFactory.create(userLocation: city)
    navigationController?.pushViewController(cityDetailViewController, animated: true)
  }
}
