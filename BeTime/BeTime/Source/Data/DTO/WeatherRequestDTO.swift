//
//  WeatherRequestDTO.swift
//  BeTime
//
//  Created by 쭌이 on 8/23/24.
//

import Foundation

struct WeatherRequestDTO {
  let baseURL: String = APIConfig.baseURL

  // 기본값 있는 프로퍼티
  let serviceKey: String = APIConfig.serviceKey
  let pageNo: String = "10"
  let numOfRows: String = "1"
  let dataType: String = "JSON"

  // 기본값이 없는 프로퍼티
  var baseDate: String
  var baseTime: String
  var nx: String
  var ny: String

  // 전달하는 데이터가 String타입이기 때문에 [String: String]으로 반환
  func parameters() -> [String: String] {
    return [
      "serviceKey": serviceKey,
      "pageNo": pageNo,
      "numOfRows": numOfRows,
      "dataType": dataType,
      "base_date": baseDate,
      "base_time": baseTime,
      "nx": nx,
      "ny": ny,
    ]
  }
}
