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

  private var saveCities: [UserLocation] = []

  private lazy var cityListTitleLabel = UILabel().then {
    $0.text = "날씨"
    $0.font = UIFont.appTitleFont
  }

  private lazy var addCityButton = UIButton().then {
    $0.setImage(UIImage(systemName: "plus"), for: .normal)
    $0.tintColor = .black
    $0.backgroundColor = .clear
    $0.contentMode = .scaleAspectFit
    $0.addAction(UIAction { _ in
      self.showPickerView()
    }, for: .touchUpInside)
  }

  private let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .singleLine
    $0.separatorColor = .black
  }

  private let pickerView = UIPickerView().then {
    $0.backgroundColor = .lightGray
    $0.layer.borderColor = UIColor.gray.cgColor
    $0.layer.borderWidth = 1
    $0.isHidden = true
  }

  private let toolbar = UIToolbar().then {
    $0.setItems(
      [UIBarButtonItem(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(cancelPickerView)
      ),
      UIBarButtonItem.flexibleSpace(),
      UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(donePickerView)
      )], animated: false
    )
    $0.isHidden = true
  }

  private lazy var emptyMessageLabel =  UILabel().then {
    $0.text = "도시를 추가해 주세요"
    $0.font = UIFont.appValueFont
    $0.textColor = .black
    $0.textAlignment = .center
    $0.isHidden = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUpDelegate()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.updateUI()
  }

  private func setUpDelegate() {
    tableView.delegate = self
    tableView.dataSource = self
    pickerView.delegate = self
    pickerView.dataSource = self
  }

  private func updateUI() {
    view.backgroundColor = .appBackgroundColor
    self.setUpSubViews()
    self.setupConstraints()
    self.updateEmptyLabel()
  }

  private func setUpSubViews() {
    [cityListTitleLabel,
     addCityButton,
     tableView,
     pickerView,
     toolbar,
     emptyMessageLabel,
    ].forEach {
      view.addSubview($0)
    }
  }

  private func setupConstraints() {
    cityListTitleLabel.pin
      .top(100)
      .left(30)
      .width(50)
      .height(30)

    addCityButton.pin
      .top(50)
      .right(20)
      .size(40)

    tableView.pin
      .below(of: cityListTitleLabel)
      .marginTop(10)
      .left()
      .right()
      .bottom(to: view.edge.bottom)

    pickerView.pin
      .bottom(self.view.safeAreaInsets.bottom)
      .left(self.view.safeAreaInsets.left)
      .right(self.view.safeAreaInsets.right)
      .height(200)

    toolbar.pin
      .left()
      .right()
      .bottom(to: pickerView.edge.top)
      .height(44)

    emptyMessageLabel.pin
      .center()
      .width(200)
      .height(50)
  }

  private func updateEmptyLabel() {
    emptyMessageLabel.isHidden = !saveCities.isEmpty
  }

  @objc private func showPickerView() {
    pickerView.isHidden = false
    toolbar.isHidden = false

    self.pickerView.pin
      .bottom(self.view.safeAreaInsets.bottom)
      .left(self.view.safeAreaInsets.left)
      .right(self.view.safeAreaInsets.right)
      .height(200)
    self.toolbar.pin
      .left()
      .right()
      .bottom(to: self.pickerView.edge.top)
      .height(44)

    self.tableView.pin
      .below(of: self.cityListTitleLabel)
      .marginTop(10)
      .left()
      .right()
      .bottom(to: self.toolbar.edge.top)

    self.view.layoutIfNeeded()
  }

  @objc private func cancelPickerView() {
    self.pickerView.pin
      .bottom(-200)
    self.toolbar.pin
      .bottom(-44)
    self.view.layoutIfNeeded()
    self.pickerView.isHidden = true
    self.toolbar.isHidden = true
  }

  @objc private func donePickerView() {
    let selectedRow = pickerView.selectedRow(inComponent: 0)
    let selectedCity = cityLocations[selectedRow]
    if !saveCities.contains(where: { $0.cityName == selectedCity.cityName }) {
      saveCities.append(selectedCity)
    }
    tableView.reloadData()
    self.updateEmptyLabel()
    self.cancelPickerView()
  }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return saveCities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "CityListTableViewCell")
    cell.textLabel?.text = saveCities[indexPath.row].cityName
    cell.backgroundColor = .clear
    return cell
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      saveCities.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    self.updateEmptyLabel()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

extension CityListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return cityLocations.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return cityLocations[row].cityName
  }
}
