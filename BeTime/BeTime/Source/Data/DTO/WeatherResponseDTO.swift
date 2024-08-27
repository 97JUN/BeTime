//
//  WeatherResponseDTO.swift
//  BeTime
//
//  Created by 쭌이 on 8/23/24.
//

import Foundation

struct WeatherResponseDTO<ItemType: Decodable>: Decodable {
    let response: Response<ItemType>
}

struct WeatherItem: Decodable {
  let baseDate: String // 발표일자
  let baseTime: String // 발표시각
  let category: Category // 자료구분 문자
  let fcstDate: String // 예측날짜
  let fcstTime: String // 예측시간
  let fcstValue: String // 예보값
  let nx: Int // 예보지점 X좌표
  let ny: Int // 예보지점 Y좌표
}

enum Category: String, Decodable {
  case temperature = "T1H"
  case precipitation = "RN1"
  case skyCondition = "SKY"
  case unknown
}

extension WeatherItem {
  func toDomain() -> Weather {
    return .init(time: fcstTime, value: fcstValue)
  }
}
