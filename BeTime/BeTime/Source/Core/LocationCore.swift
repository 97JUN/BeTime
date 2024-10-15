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

protocol LocationAuthorizationDelegate: AnyObject {
  func authorizationDidChange(status: CLAuthorizationStatus)
}

final class LocationCore: NSObject {
  static let shared = LocationCore()
  private let locationManager = CLLocationManager()
  weak var delegate: LocationAuthorizationDelegate?

  init(delegate: LocationAuthorizationDelegate? = nil) {
    super.init()
    locationManager.delegate = self
  }

  func requestLocationAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }

  func checkAuthorizationStatus() -> CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }

  func fetchUserLocation(completion: @escaping (UserLocation?) -> Void) {
    guard let location = locationManager.location else {
      completion(nil)
      return
    }

    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude

    self.fetchCityName(with: location) { cityName in
      let userLocation = UserLocation(
        cityName: cityName ?? "Unknown",
        latitude: latitude,
        longitude: longitude
      )
      completion(userLocation)
    }
  }

  private func fetchCityName(with location: CLLocation, completion: @escaping (String?) -> Void) {
    let geocoder = CLGeocoder()
    let locale = Locale(identifier: "ko-KR")
    geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placeMarks, error in
      if let error = error {
        print("Reverse geocoding failed: \(error.localizedDescription)")
        completion(nil)
        return
      }
      guard let placeMark = placeMarks?.first else {
        completion(nil)
        return
      }

      let cityName = placeMark.locality
      completion(cityName)
    }
  }
}

extension LocationCore: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    delegate?.authorizationDidChange(status: status)
  }
}
