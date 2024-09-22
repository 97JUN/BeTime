//
//  UserWeatherViewController.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//
import UIKit

import PinLayout
import RxSwift

// MARK: - UserWeatherContentView

final class UserWeatherContentView: UIView {
  private let userLocationTitle = UILabel().then {
    $0.text = "나의 위치"
    $0.font = UIFont.beTimeTitleFont
    $0.textAlignment = .center
  }

  let userCityLabel = UILabel().then {
    $0.text = "Loading..."
    $0.font = UIFont.beTimeSubTitleFont
    $0.textAlignment = .center
  }

  private let currentTemperatureTitle = UILabel().then {
    $0.text = "현재기온"
    $0.font = UIFont.beTimeSubTitleFont
    $0.textAlignment = .center
  }

  let currentTemperatureValue = UILabel().then {
    $0.text = "--°C"
    $0.font = UIFont.beTimeValueFont
    $0.textAlignment = .center
  }

  private let currentPercipitationTitle = UILabel().then {
    $0.text = "현재 강수량"
    $0.font = UIFont.beTimeSubTitleFont
    $0.textAlignment = .center
  }

  let currentPercipitationValue = UILabel().then {
    $0.text = "--"
    $0.font = UIFont.beTimeValueFont
    $0.textAlignment = .center
  }

  var userWeatherImage = UIImageView().then {
    $0.image = UIImage(named: "placholderImage")
    $0.contentMode = .scaleAspectFit
  }

  let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .singleLine
    $0.register(UserWeatherTableViewCell.self, forCellReuseIdentifier: "UserWeatherTableViewCell")
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

  private let titleLabels = ["하늘상태", "시간", "기온", "강수량"].map { title -> UILabel in
    return UILabel().then {
      $0.text = title
      $0.textAlignment = .center
      $0.font = UIFont.systemFont(ofSize: 15)
      $0.backgroundColor = .clear
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .beTimeBackgroundColor
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

  private func setupSubviews() {
    [
      userLocationTitle,
      userCityLabel,
      userWeatherImage,
      currentTemperatureTitle,
      currentTemperatureValue,
      currentPercipitationTitle,
      currentPercipitationValue,
      tableView,
      tableViewTitleView,
    ].forEach {
      addSubview($0)
    }

    for titleLabel in titleLabels {
      tableViewTitleView.addSubview(titleLabel)
    }

    for item in [topLineView, bottomLineView] {
      tableViewTitleView.addSubview(item)
    }
  }

  private func setupConstraints() {
    userLocationTitle.pin
      .hCenter()
      .top(80)
      .width(100)
      .height(30)

    userCityLabel.pin
      .below(of: userLocationTitle)
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

    currentTemperatureValue.pin
      .below(of: currentTemperatureTitle, aligned: .center)
      .marginTop(10)
      .width(100)
      .height(30)

    currentPercipitationTitle.pin
      .below(of: userWeatherImage)
      .marginTop(20)
      .right(20)
      .width(150)
      .height(30)

    currentPercipitationValue.pin
      .below(of: currentPercipitationTitle, aligned: .center)
      .marginTop(10)
      .width(100)
      .height(30)

    tableViewTitleView.pin
      .below(of: currentPercipitationValue)
      .horizontally()
      .height(50)

    titleLabels[0].pin
      .vCenter()
      .left(10)
      .width(80)
      .height(30)

    titleLabels[1].pin
      .after(of: titleLabels[0])
      .vCenter()
      .marginLeft(10)
      .width(80)
      .height(30)

    titleLabels[2].pin
      .after(of: titleLabels[1])
      .vCenter()
      .marginLeft(10)
      .width(80)
      .height(30)

    titleLabels[3].pin
      .after(of: titleLabels[2])
      .vCenter()
      .marginLeft(10)
      .width(80)
      .height(30)

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
  }
}

  // MARK: - UserWeatherViewController

final class UserWeatherViewController: UIViewController {
  private let contentView = UserWeatherContentView()
  var interactor: UserWeatherInteractor!
  private let disposeBag = DisposeBag()

  private var viewModel: UserWeatherViewModel?

  // MARK: - Lifecycle

  override func loadView() {
    self.view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.viewDidLoad()
    self.fetchViewModel()
    self.setupDelegate()
  }

  private func setupDelegate() {
    contentView.tableView.dataSource = self
    contentView.tableView.delegate = self
  }

  private func fetchViewModel() {
    interactor.userWeatherViewModelSubject
      .subscribe(onNext: { [weak self] viewModel in
        guard let self = self, let viewModel = viewModel else { return }
        self.viewModel = viewModel
        self.updateCurrentWeatherUI()
        self.contentView.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }

  private func updateCurrentWeatherUI() {
    guard let viewModel = self.viewModel else { return }
    contentView.userCityLabel.text = viewModel.cityName
    contentView.currentTemperatureValue.text = "\(viewModel.temperatureDatas[0].value)°C"
    contentView.currentPercipitationValue.text = viewModel.precipitationDatas[0].value
    contentView.userWeatherImage.image = self.updateSkyImage(value: viewModel.skyConditionDatas[0].value)
  }

  private func updateSkyImage(value: String) -> UIImage? {
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

  // MARK: - TableViewDelegate

extension UserWeatherViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel?.skyConditionDatas.count ?? 0) - 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserWeatherTableViewCell", for: indexPath) as! UserWeatherTableViewCell
    guard let viewModel = self.viewModel else { return cell }
    let newIndex = indexPath.row + 1

    let skyCondition = viewModel.skyConditionDatas[newIndex]
    let temperature = viewModel.temperatureDatas[newIndex].value
    let precipitation = viewModel.precipitationDatas[newIndex].value
    let time = skyCondition.time
    let image = self.updateSkyImage(value: skyCondition.value)

    cell.configure(with: image, timeText: time, tempText: temperature, preText: precipitation)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}
