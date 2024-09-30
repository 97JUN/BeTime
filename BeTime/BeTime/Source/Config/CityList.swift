//
//  File.swift
//  BeTime
//
//  Created by 쭌이 on 9/14/24.
//
struct CityList {
  private let cityLocations: [UserLocation] = [
    UserLocation(cityName: "서울특별시", latitude: 37.5665, longitude: 126.9780),
    UserLocation(cityName: "인천광역시", latitude: 37.4563, longitude: 126.7052),
    UserLocation(cityName: "울산광역시", latitude: 35.5384, longitude: 129.3114),
    UserLocation(cityName: "부산광역시", latitude: 35.1796, longitude: 129.0756),
    UserLocation(cityName: "대전광역시", latitude: 36.3504, longitude: 127.3845),
    UserLocation(cityName: "대구광역시", latitude: 35.8714, longitude: 128.6014),
    UserLocation(cityName: "광주광역시", latitude: 35.1595, longitude: 126.8526),
    UserLocation(cityName: "경기도", latitude: 37.4138, longitude: 127.5183),
    UserLocation(cityName: "경상남도", latitude: 35.4606, longitude: 128.2132),
    UserLocation(cityName: "경상북도", latitude: 36.4919, longitude: 128.8889),
    UserLocation(cityName: "전라북도", latitude: 35.7175, longitude: 127.1530),
    UserLocation(cityName: "전라남도", latitude: 34.8679, longitude: 126.9910),
    UserLocation(cityName: "충청남도", latitude: 36.5184, longitude: 126.8000),
    UserLocation(cityName: "충청북도", latitude: 36.6354, longitude: 127.4913),
    UserLocation(cityName: "제주도", latitude: 33.4996, longitude: 126.5312),
  ]

  func count() -> Int {
    return cityLocations.count
  }

  func cityName(at index: Int) -> String {
    return cityLocations[index].cityName
  }

  func getCity(at index: Int) -> UserLocation {
    return cityLocations[index]
  }

}
