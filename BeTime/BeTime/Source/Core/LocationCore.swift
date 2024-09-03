//
//  LocationCore.swift
//  BeTime
//
//  Created by 쭌이 on 8/23/24.
//

import CoreLocation
import Foundation

struct UserLocation {
  let cityName: String
  let latitude: Double // 위도
  let longitude: Double // 경도
}
final class LocationCore {
  static let shared = LocationCore()
  private let locationManager = CLLocationManager()

  func requestLocationAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  func checkAuthorizationStatus() -> CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }
}
