//
//  UserWeatherTableViewCell.swift
//  BeTime
//
//  Created by 쭌이 on 9/12/24.
//

import PinLayout
import UIKit

final class UserWeatherTableViewCell: UITableViewCell {
  private let weatherImage = UIImageView()
  private let timeLabel = UILabel()
  private let temperatureLabel = UILabel()
  private let precipitationLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    weatherImage.contentMode = .scaleAspectFit

    timeLabel.font = UIFont.systemFont(ofSize: 15)
    temperatureLabel.font = UIFont.systemFont(ofSize: 15)
    precipitationLabel.font = UIFont.systemFont(ofSize: 15)

    contentView.backgroundColor = .clear
    backgroundColor = .clear

    contentView.addSubview(weatherImage)
    contentView.addSubview(timeLabel)
    contentView.addSubview(temperatureLabel)
    contentView.addSubview(precipitationLabel)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.updateLayout()
  }

  private func updateLayout() {
    weatherImage.pin.left(20).vCenter().size(40)
    timeLabel.pin.after(of: weatherImage)
      .marginLeft(60).vCenter().width(60).height(30)
    temperatureLabel.pin.after(of: timeLabel)
      .marginLeft(35).vCenter().width(60).height(30)
    precipitationLabel.pin.after(of: temperatureLabel)
      .marginLeft(20).vCenter().width(60).height(30)
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
