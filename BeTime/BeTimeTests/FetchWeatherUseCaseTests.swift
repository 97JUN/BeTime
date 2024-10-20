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

  func sut(repository: WeatherDataRepositoryProtocol) -> FetchWeatherUseCaseImpl {
    return FetchWeatherUseCaseImpl(
      weatherRepository: repository
    )
  }

  func test_Repository의_requestWeatherData가_올바르게_호출됐는지_확인하는_테스트() {

    // Given
    let repositoryMock = WeatherDataRepositoryMock()
    let usecase = FetchWeatherUseCaseImpl(
      weatherRepository: repositoryMock
    )

    let locationInfo = Location(nx: "11", ny: "12")
    let dateInfo = DateTime(date: "20241012", time: "1200")
    let cityName = "Seoul"

    // When
    usecase.execute(
      locationInfo: locationInfo,
      dateInfo: dateInfo,
      cityName: cityName
    )
      .subscribe()
      .dispose()

    // Then
    XCTAssertTrue(repositoryMock.isRequestWeatherDataCalled)
  }

  func test_UseCase의_execute가_올바른_데이터를_반환하는지_테스트() {

    // Given
    let expectedForecasts = [
      WeatherForecast(category: .temperature, time: "1200", value: "20"),
      WeatherForecast(category: .skyCondition, time: "1200", value: "Clear"),
      WeatherForecast(category: .precipitation, time: "1200", value: "0")
    ]

    let locationInfo = Location(nx: "11", ny: "12")
    let dateInfo = DateTime(date: "20241012", time: "1200")
    let cityName = "Seoul"

    let repositoryMock = WeatherDataRepositoryMock()
    repositoryMock.requestWeatherDataStub = .just([])
    let useCase = sut(repository: repositoryMock)

    repositoryMock.requestWeatherDataStub = .just([
      WeatherForecast(category: .temperature, time: "1200", value: "20"),
      WeatherForecast(category: .skyCondition, time: "1200", value: "Clear"),
      WeatherForecast(category: .precipitation, time: "1200", value: "0")
    ])

    // When
    useCase.execute(
      locationInfo: locationInfo,
      dateInfo: dateInfo,
      cityName: cityName
    )
    .subscribe { forcasts in
      // Then
      XCTAssertEqual(forcasts, expectedForecasts)
    } onFailure: { error in
      XCTFail("Expected success but received error: \(error)")
    }.dispose()
  }

  func test_UseCase에서_생성한RequestDTO가_Repository에서_전달받은_requestDTO와_같은지_검증하는_테스트() {

    // Given
    let repositoryMcok = WeatherDataRepositoryMock()
    let useCase = sut(repository: repositoryMcok)

    let locationInfo = Location(nx: "11", ny: "12")
    let dateInfo = DateTime(date: "20241012", time: "1200")
    let cityName = "Seoul"

    let expectedRequestDTO = WeatherRequestDTO(
      baseDate: "20241012",
      baseTime: "1200",
      nx: "11",
      ny: "12"
    )

    // When
    useCase.execute(
      locationInfo: locationInfo,
      dateInfo: dateInfo,
      cityName: cityName
    )
      .subscribe()
      .dispose()

    // Then
    XCTAssertEqual(expectedRequestDTO, repositoryMcok.receivedRequestDTO)
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
