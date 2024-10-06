//
//  CityListViewController.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//
import UIKit

final class CityListViewController: UIViewController {
  private let contentView = CityListContentView()

  override func loadView() {
    self.view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.configure(viewModel: CityListViewModel(savedCities: []))
  }
}
