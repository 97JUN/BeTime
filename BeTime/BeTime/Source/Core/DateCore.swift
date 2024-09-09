//
//  DateCore.swift
//  BeTime
//
//  Created by 쭌이 on 8/24/24.
//

import Foundation

struct DateTime {
  let date: String // yyyyMMdd 형태
  let time: String // HHmm 형태
}

extension DateTime {
  static func getDateTime() -> DateTime {
    let currentDateTime = Date()
    // 예보를 조회 해오기 위해서는 현재시간 -30분을 적용해야 함.
    let adjustedDateTime = Calendar.current.date(byAdding: .minute, value: -30,
                                                 to: currentDateTime) ?? currentDateTime
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                             from: adjustedDateTime)

    var hour = components.hour ?? 0
    let minute = components.minute ?? 0


    let transMinute = (minute < 30) ? "00" : "30"

    var adjustedDate = adjustedDateTime
    // 00:00 ~ 00:29 까지 시간을 구할때 -30분을 하면 이전 날짜로 변경해줘야 함.
    if hour == 0 && transMinute == "00" {
      hour = 23
      adjustedDate = calendar.date(byAdding: .day, value: -1, to: adjustedDateTime) ?? adjustedDateTime
    } else if transMinute == "00" {
      hour -= 1
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let currentDate = dateFormatter.string(from: adjustedDate)
    let currentTime = "\(String(format: "%02d", hour))\(transMinute)"

    return DateTime(date: currentDate, time: currentTime)
  }
}
