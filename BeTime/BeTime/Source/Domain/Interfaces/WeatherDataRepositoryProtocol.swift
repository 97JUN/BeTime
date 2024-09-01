//
//  WeatherRepositoryProtocol.swift
//  BeTime
//
//  Created by 쭌이 on 8/29/24.
//

import Foundation

protocol WeatherDataRepositoryProtocol {
  func requestWeatherData(with: WeatherRequestDTO)
}
