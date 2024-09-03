//
//  LocationMapper.swift
//  BeTime
//
//  Created by 쭌이 on 9/3/24.
//

import Foundation

extension UserLocation {
  func convertToGRID(lat: Double, lng: Double) -> Location {
      let RE = 6371.00877 // 지구 반경 (km)
      let GRID = 5.0 // 격자 간격 (km)
      let SLAT1 = 30.0 // 투영 위도1 (degree)
      let SLAT2 = 60.0 // 투영 위도2 (degree)
      let OLON = 126.0 // 기준점 경도 (degree)
      let OLAT = 38.0 // 기준점 위도 (degree)
      let XO: Double = 43 // 기준점 X좌표 (GRID)
      let YO: Double = 136 // 기준점 Y좌표 (GRID)

      let DEGRAD = Double.pi / 180.0
      let RADDEG = 180.0 / Double.pi

      let re = RE / GRID
      let slat1 = SLAT1 * DEGRAD
      let slat2 = SLAT2 * DEGRAD
      let olon = OLON * DEGRAD
      let olat = OLAT * DEGRAD

      var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
      sn = log(cos(slat1) / cos(slat2)) / log(sn)
      var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
      sf = pow(sf, sn) * cos(slat1) / sn
      var ro = tan(Double.pi * 0.25 + olat * 0.5)
      ro = re * sf / pow(ro, sn)

      // 좌표 변환
      let ra = tan(Double.pi * 0.25 + lat * DEGRAD * 0.5)
      let adjustedRa = re * sf / pow(ra, sn)
      var theta = lng * DEGRAD - olon
      if theta > Double.pi {
          theta -= 2.0 * Double.pi
      }
      if theta < -Double.pi {
          theta += 2.0 * Double.pi
      }

      theta *= sn
      let x = Int(floor(adjustedRa * sin(theta) + XO + 0.5))
      let y = Int(floor(ro - adjustedRa * cos(theta) + YO + 0.5))

      return Location(nx: String(x), ny: String(y))
  }
}
