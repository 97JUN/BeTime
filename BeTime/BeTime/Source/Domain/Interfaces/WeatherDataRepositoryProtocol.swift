//
//  WeatherRepositoryProtocol.swift
//  BeTime
//
//  Created by 쭌이 on 8/29/24.
//

import Foundation

protocol WeatherDataRepositoryProtocol {
  func requestWeatherData(with requestDTO: WeatherRequestDTO, completion: @escaping (Result<[WeatherItem], Error>) -> Void)
}
