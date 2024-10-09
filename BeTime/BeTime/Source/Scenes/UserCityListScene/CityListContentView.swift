//
//  CityListContentView.swift
//  BeTime
//
//  Created by 쭌이 on 9/27/24.
//

import Foundation
import UIKit

import PinLayout

struct CityListViewModel {
  var savedCities: [UserLocation]?

  let cityListTitleText: String = "날씨"
  let emptyMessageText: String = "도시를 추가해주세요."
  let addButtonImage: UIImage = UIImage(systemName: "plus") ?? UIImage()
}

protocol CityListContentViewDelegate: AnyObject {
  func didSelectCity(city: UserLocation)
}

final class CityListContentView: UIView {
  private var viewModel: CityListViewModel?
  private var cityList: CityList
  weak var delegate: CityListContentViewDelegate?

  private let cityListTitleLabel = UILabel().then {
    $0.font = UIFont.title
  }

  private var addCityButton = UIButton().then {
    $0.tintColor = .black
    $0.backgroundColor = .clear
    $0.contentMode = .scaleAspectFit
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

  private let cancelButton = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )

  private let doneButton = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil
  )

  private let toolbar = UIToolbar()

  private let emptyMessageLabel = UILabel().then {
    $0.font = UIFont.labelRegular
    $0.textColor = .black
    $0.textAlignment = .center
    $0.isHidden = true
  }

  override init(frame: CGRect) {
    self.cityList = CityList()
    super.init(frame: frame)
    self.backgroundColor = .backgroundColor
    self.setupDelegate()
    self.setUpSubViews()
    self.setupToolbar()
    self.addActions()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupConstraints()
    self.updateLayout()
  }

  private func setupDelegate() {
    tableView.delegate = self
    tableView.dataSource = self
    pickerView.delegate = self
    pickerView.dataSource = self
  }

  private func setUpSubViews() {
    [
      cityListTitleLabel,
      addCityButton,
      tableView,
      pickerView,
      toolbar,
      emptyMessageLabel,
    ].forEach {
      addSubview($0)
    }
  }

  private func setupToolbar() {
    toolbar.isHidden = true
    toolbar.setItems([cancelButton, .flexibleSpace(), doneButton], animated: false)
  }

  private func addActions() {
    self.addCityButton.addAction(UIAction(handler: { [weak self] _ in
      self?.showPickerView()
    }), for: .touchUpInside)

    self.cancelButton.primaryAction = UIAction(handler: { [weak self] _ in
      self?.hidePickerView()
    })

    self.doneButton.primaryAction = UIAction(handler: { [weak self] _ in
      self?.donePickerView()
    })
  }

  private func setupConstraints() {
    cityListTitleLabel.pin
      .top(100)
      .left(30)
      .width(50)
      .height(30)

    addCityButton.pin
      .top(100)
      .right(20)
      .size(40)

    tableView.pin
      .below(of: cityListTitleLabel)
      .marginTop(10)
      .left()
      .right()
      .bottom()
      .marginBottom(safeAreaInsets.bottom)

    emptyMessageLabel.pin
      .center()
      .width(200)
      .height(50)
  }

  private func updateLayout() {
    pickerView.pin
      .bottom(safeAreaInsets.bottom)
      .left(safeAreaInsets.left)
      .right(safeAreaInsets.right)
      .height(200)

    toolbar.pin
      .left()
      .right()
      .bottom(to: pickerView.edge.top)
      .height(44)
  }

  func configure(viewModel: CityListViewModel) {
    self.viewModel = viewModel
    self.updateEmptyLabel(viewModel: viewModel)
    self.setCityListTitleLabel(with: viewModel)
    self.setAddCityButtonImage(with: viewModel)
    self.tableView.reloadData()
  }

  private func updateEmptyLabel(viewModel: CityListViewModel) {
    self.emptyMessageLabel.text = viewModel.emptyMessageText
    if let savedCities = viewModel.savedCities, !savedCities.isEmpty {
      self.emptyMessageLabel.isHidden = true
    } else {
      self.emptyMessageLabel.isHidden = false
    }
  }

  private func setCityListTitleLabel(with viewModel: CityListViewModel) {
    self.cityListTitleLabel.text = viewModel.cityListTitleText
  }

  private func setAddCityButtonImage(with viewModel: CityListViewModel) {
    self.addCityButton.setImage(viewModel.addButtonImage, for: .normal)
  }

  private func hidePickerView() {
    self.pickerView.isHidden = true
    self.toolbar.isHidden = self.pickerView.isHidden
  }

  private func showPickerView() {
    self.pickerView.isHidden = false
    self.toolbar.isHidden = self.pickerView.isHidden
  }

  private func donePickerView() {
    let selectedRow = pickerView.selectedRow(inComponent: 0)
    guard selectedRow >= 0 && selectedRow < cityList.count() else { return }
    let selectedCity = cityList.getCity(at: selectedRow)

    if !(viewModel?.savedCities?.contains(where: { $0.cityName == selectedCity.cityName }) ?? false) {
      viewModel?.savedCities?.append(selectedCity)
      let userLocation = UserLocation(
          cityName: selectedCity.cityName,
          latitude: selectedCity.latitude,
          longitude: selectedCity.longitude
        )
      UserLocationManager.shared.saveUserLocation(userLocation)
    }
    self.configure(viewModel: viewModel ?? CityListViewModel())
    self.updateEmptyLabel(viewModel: viewModel ?? CityListViewModel())
    self.hidePickerView()
  }
}

extension CityListContentView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel?.savedCities?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "CityListTableViewCell")
    cell.textLabel?.text = self.viewModel?.savedCities?[indexPath.row].cityName ?? "도시 없음"
    cell.backgroundColor = .clear
    return cell
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let cityNameToDelete = viewModel?.savedCities?[indexPath.row].cityName ?? ""
      UserLocationManager.shared.deleteCity(cityNameToDelete)
      viewModel?.savedCities?.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    self.updateEmptyLabel(viewModel: viewModel ?? CityListViewModel())
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedCity = viewModel?.savedCities?[indexPath.row] else { return }
    delegate?.didSelectCity(city: selectedCity)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

extension CityListContentView: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return cityList.count()
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return cityList.cityName(at: row)
  }
}
