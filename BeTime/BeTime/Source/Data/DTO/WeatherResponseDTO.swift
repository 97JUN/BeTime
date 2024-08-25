//
//  WeatherResponseDTO.swift
//  BeTime
//
//  Created by 쭌이 on 8/23/24.
//

import Foundation

struct WeatherResponseDTO: Decodable {
  let response: Response
}

struct Response: Decodable {
  let header: Header
  let body: Body
}

struct Header: Decodable {
  let resultCode: String
  let resultMsg: String
}

struct Body: Decodable {
  let dataType: String
  let items:[WeatherItem]
  let pageNo: Int
  let numOfRows: Int
  let totalCount: Int
}

struct WeatherItem: Decodable {
  let baseDate: String
  let baseTime: String
  let category: String
  let fcstDate: String
  let fcstTime: String
  let fcstValue: String
  let nx: Int
  let ny: Int
}

extension WeatherItem {
  func toDomain() -> Weather {
    return .init(time: fcstTime, value: fcstValue)
  }
}
