//
//  UserWeatherViewController.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import PinLayout
import RxSwift
import UIKit

final class UserWeatherViewController: UIViewController {
  var interactor: UserWeatherInteractor!
  private let disposeBag = DisposeBag()

  // MARK: - UI

  private let tableView = UITableView()

  private var userLocationTitle: UILabel = {
    let label = UILabel()
    label.text = "나의 위치"
    label.font = UIFont.systemFont(ofSize: 25)
    label.textAlignment = .center
    return label
  }()

  private var userCityLabel: UILabel = {
    let label = UILabel()
    label.text = "서울특별시"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()

  private lazy var currentTemperatureTitle: UILabel = {
    let label = UILabel()
    label.text = "현재기온"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()

  private var currentTemperatureValue: UILabel = {
    let label = UILabel()
    label.text = "20°C"
    label.font = UIFont.systemFont(ofSize: 15)
    label.textAlignment = .center
    return label
  }()

  private lazy var currentPercipitationTitle: UILabel = {
    let label = UILabel()
    label.text = "현재 강수량"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()

  private var currentPercipitationValue: UILabel = {
    let label = UILabel()
    label.text = "1mm 미만"
    label.font = UIFont.systemFont(ofSize: 15)
    label.textAlignment = .center
    return label
  }()

  private var userWeatherImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "sun.beTime")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  // MARK: - Lifecycle

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

// MARK: - UI Method

extension UserWeatherViewController {
  override func viewDidLayoutSubviews() {
    self.updateUI()
    self.setupTableViewTitle()
  }

  private func updateUI() {
    view.backgroundColor = UIColor(red: 160/255, green: 194/255, blue: 204/255, alpha: 1.0)
    self.setupSubviews()
    self.setupConstraints()
    self.setupTableView()
  }

  private func setupSubviews() {
    [userLocationTitle, userCityLabel, userWeatherImage,
     currentTemperatureTitle, currentTemperatureValue,
     currentPercipitationTitle, currentPercipitationValue,
     tableView].forEach {
      view.addSubview($0)
    }
  }

  // Constraint
  private func setupConstraints() {
    userLocationTitle.pin.top(80).hCenter().width(100).height(30)
    userCityLabel.pin.below(of: userLocationTitle)
      .marginTop(15).hCenter().width(100).height(25)
    userWeatherImage.pin.below(of: userCityLabel)
      .marginTop(30).hCenter().size(150)
    currentTemperatureTitle.pin.below(of: userWeatherImage)
      .marginTop(20).left(20).width(150).height(30)
    currentTemperatureValue.pin.below(of: currentTemperatureTitle, aligned: .center)
      .marginTop(10).width(100).height(30)
    currentPercipitationTitle.pin.below(of: userWeatherImage)
      .marginTop(20).right(20).width(150).height(30)
    currentPercipitationValue.pin.below(of: currentPercipitationTitle, aligned: .center)
      .marginTop(10).width(100).height(30)
    setupTableViewTitle()
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .singleLine
  }

  private func setupTableViewTitle() {
    let tableViewTitleView = UIView()
    tableViewTitleView.backgroundColor = .clear
    view.addSubview(tableViewTitleView)
    view.addSubview(tableView)

    let topLineView = createLineView()
    tableViewTitleView.addSubview(topLineView)

    let bottomLineView = createLineView()
    tableViewTitleView.addSubview(bottomLineView)

    let titles = ["하늘상태", "시간", "기온", "강수량"]
    let labels = titles.map { title -> UILabel in
      let label = UILabel()
      label.text = title
      label.textAlignment = .center
      label.backgroundColor = .clear
      label.font = UIFont.systemFont(ofSize: 15)
      tableViewTitleView.addSubview(label)
      return label
    }

    tableViewTitleView.pin.below(of: currentPercipitationValue).horizontally().height(50)

    labels[0].pin.left(10).vCenter().width(80).height(30)
    labels[1].pin.after(of: labels[0]).marginLeft(10).vCenter().width(80).height(30)
    labels[2].pin.after(of: labels[1]).marginLeft(10).vCenter().width(80).height(30)
    labels[3].pin.after(of: labels[2]).marginLeft(10).vCenter().width(80).height(30)

    topLineView.pin.top().horizontally().height(1)
    bottomLineView.pin.bottom().horizontally().height(1)

    tableView.pin.below(of: tableViewTitleView).left().right().bottom()
  }

  private func createLineView() -> UIView {
    let lineView = UIView()
    lineView.backgroundColor = .gray
    return lineView
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

extension UserWeatherViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel?.text = "\(indexPath.row)"
    cell.backgroundColor = .clear
    return cell
  }
}
