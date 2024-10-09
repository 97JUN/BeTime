//
//  CityDetailContentView.swift
//  BeTime
//
//  Created by 쭌이 on 10/6/24.
//

import Foundation
import UIKit

import PinLayout

struct CityDetailViewModel {
  let skyConditionDatas: [WeatherForecast]?
  let temperatureDatas: [WeatherForecast]?
  let precipitationDatas: [WeatherForecast]?
  let cityName: String?

  let currentTemperatureTitle: String = "현재 기온"
  let currentPrecipitationTitle: String = "현재 강수량"
  let titles: [String] = [
    "하늘상태",
    "시간",
    "기온",
    "강수량",
  ]
}

final class CityDetailContentView: UIView {
  private var viewModel: CityDetailViewModel?

  private let userCityLabel = UILabel().then {
    $0.font = UIFont.subtitle
    $0.textAlignment = .center
  }

  private let currentTemperatureTitle = UILabel().then {
    $0.font = UIFont.subtitle
    $0.textAlignment = .center
  }

  private let currentTemperatureLabel = UILabel().then {
    $0.font = UIFont.labelRegular
    $0.textAlignment = .center
  }

  private let currentPrecipitationTitle = UILabel().then {
    $0.font = UIFont.subtitle
    $0.textAlignment = .center
  }

  private let currentPrecipitationLabel = UILabel().then {
    $0.font = UIFont.labelRegular
    $0.textAlignment = .center
  }

  private var userWeatherImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .singleLine
  }

  private let tableViewTitleView = UIView().then {
    $0.backgroundColor = .clear
  }

  private let topLineView = UIView().then {
    $0.backgroundColor = .lightGray
  }

  private let bottomLineView = UIView().then {
    $0.backgroundColor = .lightGray
  }

  private var titleLabels: [UILabel] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure(viewModel: viewModel ??
      CityDetailViewModel(
        skyConditionDatas: [],
        temperatureDatas: [],
        precipitationDatas: [],
        cityName: ""
      )
    )
    self.backgroundColor = .backgroundColor
    self.setDelegate()
    self.setupUIElements()
    self.setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupConstraints()
  }

  private func setDelegate() {
    tableView.delegate = self
    tableView.dataSource = self
  }

  private func setupUIElements() {
    self.tableView.register(UserWeatherTableViewCell.self, forCellReuseIdentifier: "UserWeatherTableViewCell")
  }

  private func setupSubviews() {
    [
      userCityLabel,
      userWeatherImage,
      currentTemperatureTitle,
      currentTemperatureLabel,
      currentPrecipitationTitle,
      currentPrecipitationLabel,
      tableView,
      tableViewTitleView,
    ].forEach {
      addSubview($0)
    }

    titleLabels.forEach {
      tableViewTitleView.addSubview($0)
    }

    for item in [topLineView, bottomLineView] {
      tableViewTitleView.addSubview(item)
    }
  }

  private func setupConstraints() {

    userCityLabel.pin
      .top(80)
      .hCenter()
      .marginTop(15)
      .width(100)
      .height(25)

    userWeatherImage.pin
      .below(of: userCityLabel)
      .hCenter()
      .marginTop(30)
      .size(150)

    currentTemperatureTitle.pin
      .below(of: userWeatherImage)
      .marginTop(20)
      .left(20)
      .width(150)
      .height(30)

    currentTemperatureLabel.pin
      .below(of: currentTemperatureTitle, aligned: .center)
      .marginTop(10)
      .width(100)
      .height(30)

    currentPrecipitationTitle.pin
      .below(of: userWeatherImage)
      .marginTop(20)
      .right(20)
      .width(150)
      .height(30)

    currentPrecipitationLabel.pin
      .below(of: currentPrecipitationTitle, aligned: .center)
      .marginTop(10)
      .width(100)
      .height(30)

    tableViewTitleView.pin
      .below(of: currentPrecipitationLabel)
      .horizontally()
      .height(50)

    topLineView.pin
      .top()
      .horizontally()
      .height(1)

    bottomLineView.pin
      .bottom()
      .horizontally()
      .height(1)

    tableView.pin
      .below(of: tableViewTitleView)
      .left()
      .right()
      .bottom()

    guard !titleLabels.isEmpty else {
      return
    }

    for index in titleLabels.indices {
      if index == 0 {
        titleLabels[index].pin
          .vCenter()
          .left(10)
          .width(80)
          .height(30)
      } else {
        titleLabels[index].pin
          .vCenter()
          .after(of: titleLabels[index - 1])
          .marginLeft(10)
          .width(80)
          .height(30)
      }
    }
  }

  func configure(viewModel: CityDetailViewModel) {
    self.viewModel = viewModel
    self.setTemperatureTitle(with: viewModel.currentTemperatureTitle)
    self.setPrecipitationTitle(with: viewModel.currentPrecipitationTitle)
    self.setupTitleLabels(with: viewModel.titles)
    for (index, label) in titleLabels.enumerated() {
      label.text = viewModel.titles[index]
    }
    self.setUserCityLabel(with: viewModel.cityName)

    if let temperatureData = viewModel.temperatureDatas?.first?.value,
       let precipitationData = viewModel.precipitationDatas?.first?.value,
       let skyConditionData = viewModel.skyConditionDatas?.first?.value
    {
      self.setTemperatureLabel(with: temperatureData)
      self.setPrecipitationLabel(with: precipitationData)
      self.setSkyImage(with: self.updateSkyImage(value: skyConditionData))

    } else {
      self.setTemperatureLabel(with: "--")
      self.setPrecipitationLabel(with: "강수 데이터 없음")
      self.setSkyImage(with: self.updateSkyImage(value: nil))
    }
    self.tableView.reloadData()
  }

  private func setTemperatureTitle(with title: String) {
    self.currentTemperatureTitle.text = title
  }

  private func setTemperatureLabel(with temperature: String?) {
    self.currentTemperatureLabel.text = "\(temperature ?? "--")°C"
  }

  private func setPrecipitationTitle(with title: String) {
    self.currentPrecipitationTitle.text = title
  }

  private func setPrecipitationLabel(with precipitation: String?) {
    self.currentPrecipitationLabel.text = precipitation ?? "강수 데이터 없음"
  }

  private func setUserCityLabel(with cityName: String?) {
    self.userCityLabel.text = cityName ?? "도시 정보 없음"
  }

  private func setSkyImage(with image: UIImage?) {
    self.userWeatherImage.image = image ?? UIImage()
  }

  private func setupTitleLabels(with titles: [String]) {
    self.titleLabels = titles.map { title in
      UILabel().then { label in
        label.text = title
        label.textAlignment = .center
        label.font = .labelRegular
        label.backgroundColor = .clear
      }
    }
  }

  private func updateSkyImage(value: String?) -> UIImage? {
    guard let value = value else { return UIImage() }
    switch value {
    case "1":
      return UIImage(named: "sun.beTime")
    case "3":
      return UIImage(named: "cloud.beTime")
    case "4":
      return UIImage(named: "umbrella.beTime")
    default:
      return UIImage()
    }
  }
}

extension CityDetailContentView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel?.skyConditionDatas?.count ?? 0) - 1
    //viewModel의 첫번쨰 데이터는 TableView의 상단에서 표시하기 때문에 tableView 갯수 -1 개 하도록.
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserWeatherTableViewCell", for: indexPath) as! UserWeatherTableViewCell
    guard let viewModel = self.viewModel else { return cell }
    let newIndex = indexPath.row + 1

    guard let skyConditionDatas = viewModel.skyConditionDatas, skyConditionDatas.indices.contains(newIndex),
          let temperatureDatas = viewModel.temperatureDatas, temperatureDatas.indices.contains(newIndex),
          let precipitationDatas = viewModel.precipitationDatas, precipitationDatas.indices.contains(newIndex)
    else {
      return cell
    }

    let skyCondition = viewModel.skyConditionDatas?[newIndex]
    let image = self.updateSkyImage(value: skyCondition?.value)
    let time = skyCondition?.time
    let temperature = viewModel.temperatureDatas?[newIndex].value
    let precipitation = viewModel.precipitationDatas?[newIndex].value

    let cellViewModel = UserWeatherCellViewModel(
      image: image,
      timeText: time,
      temperatureText: temperature,
      precipitationText: precipitation
    )
    cell.configure(with: cellViewModel)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

