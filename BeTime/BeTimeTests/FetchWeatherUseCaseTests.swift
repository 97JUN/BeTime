//
//  FetchWeatherUseCaseTests.swift
//  BeTimeTests
//
//  Created by 쭌이 on 10/14/24.
//
import RxSwift
import XCTest

@testable import BeTime

final class FetchWeatherUseCaseTests: XCTestCase {
  // SUT (System Under Test)
  func sut() -> FetchWeatherUseCaseImpl {
    return FetchWeatherUseCaseImpl(
      weatherRepository: WeatherDataRepositoryMock())
  }

  func test_delegateMock객체에_데이터가_잘전달됐는지_확인() {
    // Given

    let expectedForecasts = [
      WeatherForecast(category: .temperature, time: "1200", value: "20"),
      WeatherForecast(category: .skyCondition, time: "1200", value: "Clear"),
      WeatherForecast(category: .precipitation, time: "1200", value: "0")
    ]

    let useCase = sut()
    let delegateMock = FetchWeatherUseCaseDelegateMock()
    useCase.delegate = delegateMock

    let locationInfo = Location(nx: "11", ny: "12")
    let dateInfo = DateTime(date: "20241012", time: "1200")
    let cityName = "Seoul"

    // When
    useCase.execute(locationInfo: locationInfo, dateInfo: dateInfo, cityName: cityName)

    // Then
    XCTAssertNotNil(delegateMock.result)
    switch delegateMock.result {
    case .success(let forecasts):
      XCTAssertEqual(forecasts, expectedForecasts)
    default:
      XCTFail("Expected a success result.")
    }
  }
}

final class WeatherDataRepositoryMock: WeatherDataRepositoryProtocol {
  var requestWeatherDataStub: Single<[WeatherForecast]> = .just([
    WeatherForecast(category: .temperature, time: "1200", value: "20"),
    WeatherForecast(category: .skyCondition, time: "1200", value: "Clear"),
    WeatherForecast(category: .precipitation, time: "1200", value: "0")
  ])

  func requestWeatherData(request: WeatherRequestDTO) -> Single<[WeatherForecast]> {
    return requestWeatherDataStub
  }
}

final class FetchWeatherUseCaseDelegateMock: FetchWeatherUseCaseDelegate {
  var result: Result<[WeatherForecast], Error>?

  func didUpdateForcastDatas(_ weatherForcasts: Result<[WeatherForecast], Error>, cityName: String) {
    result = weatherForcasts
  }
}
