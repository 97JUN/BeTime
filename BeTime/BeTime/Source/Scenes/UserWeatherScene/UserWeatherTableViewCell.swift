//
//  UserWeatherTableViewCell.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import UIKit

import PinLayout
import Then

final class UserWeatherTableViewCell: UITableViewCell {
  
  private let weatherImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private let timeLabel = UILabel().then {
    $0.font = UIFont.beTimeValueFont
  }

  private let temperatureLabel = UILabel().then {
    $0.font = UIFont.beTimeValueFont
  }

  private let precipitationLabel = UILabel().then {
    $0.font = UIFont.beTimeValueFont
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
      weatherImage,
      timeLabel,
      temperatureLabel,
      precipitationLabel,
    ].forEach {
      addSubview($0)
    }
  }

  private func updateLayout() {
    weatherImage.pin
      .vCenter()
      .left(20)
      .size(40)

    timeLabel.pin
      .after(of: weatherImage)
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

  func configure(with image: UIImage?, timeText: String, tempText: String, preText: String) {
    let hour = Int(timeText.prefix(2))!
    let minute = Int(timeText.suffix(2))!

    weatherImage.image = image
    timeLabel.text = String(format: "%02d:%02d", hour, minute)
    temperatureLabel.text = "\(tempText)°C"
    precipitationLabel.text = preText
  }
}
