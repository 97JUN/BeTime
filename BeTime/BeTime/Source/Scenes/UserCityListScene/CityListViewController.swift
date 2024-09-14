//
//  CityListViewController.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import PinLayout
import Then
import UIKit

final class CityListViewController: UIViewController {

  private lazy var cityListTitleLabel = UILabel().then {
    $0.text = "날씨"
    $0.font = UIFont.appTitleFont
  }

  private lazy var addCityButton = UIButton().then {
    $0.setImage(UIImage(systemName: "plus"), for: .normal)
    $0.tintColor = .black // 원하는 색상으로 설정
    $0.backgroundColor = .clear
    $0.contentMode = .scaleAspectFit
    $0.addAction(UIAction { _ in
      print("Plus Button Tapped")
    }, for: .touchUpInside)
  }

  private let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .singleLine
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    self.updateUI()
  }

  private func updateUI() {
    view.backgroundColor = .appBackgroundColor
    self.setUpSubViews()
    self.setupConstraint()
  }

  private func setUpSubViews() {
    [cityListTitleLabel,addCityButton,tableView
    ,].forEach {
      view.addSubview($0)
    }
  }

  private func setupConstraint() {
    cityListTitleLabel.pin.top(100).left(30).width(50).height(30)
    addCityButton.pin.top(50).right(20).size(40)
    tableView.pin.below(of: cityListTitleLabel)
      .marginTop(10).left().right().top().bottom()
  }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "CityListTableViewCell")
    cell.textLabel?.text = "Test"
    cell.backgroundColor = .clear
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}
