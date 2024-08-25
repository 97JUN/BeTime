//
//  WeatherRequestDTO.swift
//  BeTime
//
//  Created by 쭌이 on 8/23/24.
//

import Foundation

struct WeatherRequestDTO {
  static let baseURL = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"

    // 기본값 있는 프로퍼티
    var serviceKey: String = "82AhPCcoQ68FQepqQPEtdIUdXktjvffPdhesYZmqGhGhaVt6YuRy0PhhdF9IaayPbCQwOWgHpcJwSET29msx5A%3D%3D"
    var pageNo: String = "10"
    var numOfRows: String = "1"

    // 기본값이 없는 프로퍼티
    var dataType: String
    var baseDate: String
    var baseTime: String
    var nx: String
    var ny: String

    // AlamoFire parameter 생성 Dictionary로 변환
    func toDictionary() -> [String: String] {
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
