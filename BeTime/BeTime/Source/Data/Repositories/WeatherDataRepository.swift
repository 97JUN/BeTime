//
//  WeatherRepository.swift
//  BeTime
//
//  Created by 쭌이 on 8/27/24.
//

import Foundation

final class WeatherDataRepository: WeatherDataRepositoryProtocol {
  func requestWeatherData(with requestDTO: WeatherRequestDTO, completion: @escaping (Result<[WeatherItem], Error>) -> Void) {
    //     AlamoFire Manager를 통해 RequestDTO를 가지고 GET 요청
  }
}
