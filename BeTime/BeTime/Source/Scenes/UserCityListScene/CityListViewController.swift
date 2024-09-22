//
//  CityListViewController.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//
import UIKit

import PinLayout
import Then

  // MARK: - CityListContentView

final class CityListContentView: UIView {
  let cityListTitleLabel = UILabel().then {
    $0.text = "날씨"
    $0.font = UIFont.beTimeTitleFont
  }

  var addCityButton = UIButton().then {
    $0.setImage(UIImage(systemName: "plus"), for: .normal)
    $0.tintColor = .black
    $0.backgroundColor = .clear
    $0.contentMode = .scaleAspectFit
  }

  let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .singleLine
    $0.separatorColor = .black
  }

  let pickerView = UIPickerView().then {
    $0.backgroundColor = .lightGray
    $0.layer.borderColor = UIColor.gray.cgColor
    $0.layer.borderWidth = 1
    $0.isHidden = true
  }

  let cancelButton = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )

  let doneButton = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil
  )

  let toolbar = UIToolbar()

  let emptyMessageLabel = UILabel().then {
    $0.text = "도시를 추가해 주세요"
    $0.font = UIFont.beTimeValueFont
    $0.textColor = .black
    $0.textAlignment = .center
    $0.isHidden = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupToolbar()
    setUpSubViews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupConstraints()
  }

  private func setupToolbar() {
    toolbar.isHidden = true
    toolbar.setItems([cancelButton, .flexibleSpace(), doneButton], animated: false)
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
      .bottom()
      .marginBottom(safeAreaInsets.bottom)

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

    emptyMessageLabel.pin
      .center()
      .width(200)
      .height(50)
  }
}

// MARK: - CityListViewController

final class CityListViewController: UIViewController {
  private var saveCities: [UserLocation] = []
  private let contentView = CityListContentView()

  override func loadView() {
    self.view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUpDelegate()
    self.updateEmptyLabel()
    self.addActions()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.backgroundColor = .beTimeBackgroundColor
  }

  private func setUpDelegate() {
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = self
    contentView.pickerView.delegate = self
    contentView.pickerView.dataSource = self
  }

  private func updateEmptyLabel() {
    contentView.emptyMessageLabel.isHidden = !saveCities.isEmpty
  }

  private func addActions() {
    contentView.addCityButton.addAction(UIAction(handler: { [weak self] _ in
      self?.showPickerView()
    }), for: .touchUpInside)

    contentView.cancelButton.primaryAction = UIAction(handler: { [weak self] _ in
      self?.cancelPickerView()
    })

    contentView.doneButton.primaryAction = UIAction(handler: { [weak self] _ in
      guard let selectedRow = self?.contentView.pickerView.selectedRow(inComponent: 0) else { return }
      let selectedCity = cityLocations[selectedRow]
      self?.donePickerView(with: selectedCity)
    })
  }

  private func showPickerView() {
    contentView.pickerView.isHidden = false
    contentView.toolbar.isHidden = false

    contentView.pickerView.pin
      .bottom(self.view.safeAreaInsets.bottom)
      .left(self.view.safeAreaInsets.left)
      .right(self.view.safeAreaInsets.right)
      .height(200)

    contentView.toolbar.pin
      .left()
      .right()
      .bottom(to: contentView.pickerView.edge.top)
      .height(44)

    contentView.tableView.pin
      .below(of: contentView.cityListTitleLabel)
      .marginTop(10)
      .left()
      .right()
      .bottom(to: contentView.toolbar.edge.top)
  }

  private func cancelPickerView() {
    contentView.pickerView.isHidden = true
    contentView.toolbar.isHidden = true
  }

  func donePickerView(with selectedCity: UserLocation) {
    if !saveCities.contains(where: { $0.cityName == selectedCity.cityName }) {
      saveCities.append(selectedCity)
    }
    contentView.tableView.reloadData()
    self.updateEmptyLabel()
    self.cancelPickerView()
  }
}

// MARK: - TableViewDelegate

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

// MARK: - PickerViewDelegate

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
