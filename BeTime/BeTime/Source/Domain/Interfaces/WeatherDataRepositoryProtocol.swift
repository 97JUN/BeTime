//
//  WeatherRepositoryProtocol.swift
//  BeTime
//
//  Created by 쭌이 on 8/29/24.
//

import Foundation
import RxSwift

protocol WeatherDataRepositoryProtocol {
  func requestWeatherData(request: WeatherRequestDTO) -> Single<[WeatherForecast]>
}
