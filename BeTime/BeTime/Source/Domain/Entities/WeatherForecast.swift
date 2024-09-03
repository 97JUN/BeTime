//
//  WeatherForecast.swift
//  BeTime
//
//  Created by 쭌이 on 8/23/24.
//

import Foundation

struct WeatherForecast {
  let category: Category
  let time: String
  let value: String
}

enum Category: String {
  case temperature = "T1H"
  case precipitation = "RN1"
  case skyCondition = "SKY"
  case unknown
}
