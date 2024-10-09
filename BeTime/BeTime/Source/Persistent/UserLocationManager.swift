//
//  UserLocationManager.swift
//  BeTime
//
//  Created by 쭌이 on 10/9/24.
//

import Foundation

final class UserLocationManager {

  static let shared = UserLocationManager()

  private let userDefaultsKey = "userLocation"

  func deleteCity(named cityName: String) {
    var locations = loadUserLocations()

    if let indexToDelete = locations.firstIndex(where: { $0.cityName == cityName }) {
      locations.remove(at: indexToDelete)

      if let encodedData = try? JSONEncoder().encode(locations) {
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
      }
    }
  }

  func saveUserLocation(_ location: UserLocation) {
    var locations = loadUserLocations()
    locations.append(location)

    if let encodedData = try? JSONEncoder().encode(locations) {
      UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
  }

  func loadUserLocations() -> [UserLocation] {
    guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
    return (try? JSONDecoder().decode([UserLocation].self, from: data)) ?? []
  }

  func deleteCity(_ cityName: String) {
    var locations = loadUserLocations()

    if let cityToDelete = locations.firstIndex(where: { $0.cityName == cityName }) {
      locations.remove(at: cityToDelete)

      if let encodedData = try? JSONEncoder().encode(locations) {
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
      }
    }
  }
}
