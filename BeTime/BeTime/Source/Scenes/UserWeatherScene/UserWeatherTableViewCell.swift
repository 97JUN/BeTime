//
//  UserWeatherTableViewCell.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import UIKit

import PinLayout
import Then

struct UserWeatherCellViewModel {
  let image: UIImage?
  let timeText: String?
  let temperatureText: String?
  let precipitationText: String?
}

final class UserWeatherTableViewCell: UITableViewCell {
  private let weatherImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private let timeLabel = UILabel().then {
    $0.font = UIFont.labelRegular
  }

  private let temperatureLabel = UILabel().then {
    $0.font = UIFont.labelRegular
  }

  private let precipitationLabel = UILabel().then {
    $0.font = UIFont.labelRegular
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    setupSubViews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.updateLayout()
  }

  private func setupSubViews() {
    [
      weatherImageView,
      timeLabel,
      temperatureLabel,
      precipitationLabel,
    ].forEach {
      addSubview($0)
    }
  }

  private func updateLayout() {
    weatherImageView.pin
      .vCenter()
      .left(20)
      .size(40)

    timeLabel.pin
      .after(of: weatherImageView)
      .vCenter()
      .marginLeft(60)
      .width(60)
      .height(30)

    temperatureLabel.pin
      .after(of: timeLabel)
      .vCenter()
      .marginLeft(35)
      .width(60)
      .height(30)

    precipitationLabel.pin
      .after(of: temperatureLabel)
      .vCenter()
      .marginLeft(20)
      .width(60)
      .height(30)
  }

  func configure(with viewModel: UserWeatherCellViewModel) {
    let hour = Int(viewModel.timeText?.prefix(2) ?? "00") ?? 0
    let minute = Int(viewModel.timeText?.suffix(2) ?? "00") ?? 0

    weatherImageView.image = viewModel.image
    timeLabel.text = String(format: "%02d:%02d", hour, minute)
    temperatureLabel.text = "\((viewModel.temperatureText) ?? "--")°C"
    precipitationLabel.text = viewModel.precipitationText
  }
}
