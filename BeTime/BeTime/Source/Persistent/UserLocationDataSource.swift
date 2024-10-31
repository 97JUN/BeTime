//
//  UserLocationDataSource.swift
//  BeTime
//
//  Created by 쭌이 on 10/10/24.
//

import Foundation


protocol UserLocationDataSourceService {
  func loadUserLocations() -> [UserLocation]
  func deleteCity(_ cityName: String)
  func saveUserLocation(_ location: UserLocation)
}

final class UserLocationDataSource: UserLocationDataSourceService {
  static let shared = UserLocationDataSource()

  private let userDefaultsKey = "userLocation"

  func loadUserLocations() -> [UserLocation] {
    guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
    return (try? JSONDecoder().decode([UserLocation].self, from: data)) ?? []
  }

  func saveUserLocation(_ location: UserLocation) {
    var locations = loadUserLocations()
    locations.append(location)

    if let encodedData = try? JSONEncoder().encode(locations) {
      UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
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
