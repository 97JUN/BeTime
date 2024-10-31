//
//  FetchWeatherUseCaseTests.swift
//  BeTimeTests
//
//  Created by 쭌이 on 10/16/24.
//

import XCTest

import RxSwift

@testable import BeTime

final class FetchWeatherUseCaseTests: XCTestCase {
  private func sut(repository: WeatherDataRepositoryProtocol) -> FetchWeatherUseCaseImpl {
    return FetchWeatherUseCaseImpl(
      weatherRepository: repository // WeatherDataRepositoryMock()
    )
  }

  func test_실행_시_Repository의_requestWeatherData에_전달된_requestDTO를_확인_후_호출_성공_시_날씨데이터를_반환합니다() {
    // Given
    let repositoryMock = WeatherDataRepositoryMock()
    let usecase = FetchWeatherUseCaseImpl(
      weatherRepository: repositoryMock
    )

    let locationInfo = Location(nx: "11", ny: "12")
    let dateInfo = DateTime(date: "20241012", time: "1200")
    let cityName = "Seoul"

    let expectedForecasts = [
      WeatherForecast(category: .temperature, time: "1200", value: "20"),
      WeatherForecast(category: .skyCondition, time: "1200", value: "Clear"),
      WeatherForecast(category: .precipitation, time: "1200", value: "0")
    ]

    let expectedRequestDTO = WeatherRequestDTO(
      baseDate: "20241012",
      baseTime: "1200",
      nx: "11",
      ny: "12"
    )

    // When
    usecase.execute(
      locationInfo: locationInfo,
      dateInfo: dateInfo,
      cityName: cityName
    )
    .subscribe { forcasts in
      // Then
      XCTAssertEqual(forcasts, expectedForecasts)
      XCTAssertEqual(repositoryMock.receivedRequestDTO, expectedRequestDTO)
      XCTAssertTrue(repositoryMock.isRequestWeatherDataCalled)
    } onFailure: { error in
      XCTFail("Expected success but received error: \(error)")
    }.dispose()
  }

  func test_실행_시_Repository의_requestWeatherData에_전달된_requestDTO_호출_실패_시_오류를_반환합니다() {
    // Given
    let repositoryMock = WeatherDataRepositoryMock()
    let usecase = FetchWeatherUseCaseImpl(
      weatherRepository: repositoryMock
    )

    let locationInfo = Location(nx: "11", ny: "12")
    let dateInfo = DateTime(date: "20241012", time: "1200")
    let cityName = "Seoul"

    let expectedError = NSError(domain: "NetworkError", code: -1, userInfo: nil)
    repositoryMock.requestWeatherDataStub = .error(expectedError)

    // When
    usecase.execute(
      locationInfo: locationInfo,
      dateInfo: dateInfo,
      cityName: cityName
    )
    .subscribe { forecasts in
      XCTFail("Expected failure but received forecasts: \(forecasts)")
    } onFailure: { error in
      // Then
      let nsError = error as NSError
      XCTAssertEqual(nsError, expectedError)
      XCTAssertTrue(repositoryMock.isRequestWeatherDataCalled)
    }.dispose()
  }

}

final class WeatherDataRepositoryMock: WeatherDataRepositoryProtocol {
  var requestWeatherDataStub: Single<[WeatherForecast]> = .just([])
  var isRequestWeatherDataCalled: Bool = false
  var receivedRequestDTO: WeatherRequestDTO?

  func requestWeatherData(request: WeatherRequestDTO) -> Single<[WeatherForecast]> {
    isRequestWeatherDataCalled = !isRequestWeatherDataCalled
    receivedRequestDTO = request
    return requestWeatherDataStub
  }
}
