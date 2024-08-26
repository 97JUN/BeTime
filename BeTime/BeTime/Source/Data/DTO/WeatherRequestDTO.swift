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
    var serviceKey: String = APIConfig.serviceKey
    var pageNo: String = "10"
    var numOfRows: String = "1"

    // 기본값이 없는 프로퍼티
    var dataType: String
    var baseDate: String
    var baseTime: String
    var nx: String
    var ny: String

    // AlamoFire parameter 생성 Dictionary로 변환
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
