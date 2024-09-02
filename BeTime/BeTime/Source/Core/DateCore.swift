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

  static func getDateTime() -> DateTime {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let currentDate = dateFormatter.string(from: Date())

    let calender = Calendar.current
    let components = calender.dateComponents([.hour, .minute], from: Date())
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let transMinute = minute < 30 ? "0" : "30"
    let currentTime = "\(String(format: "%02d", hour))\(transMinute)"

    return DateTime(date: currentDate, time: currentTime)
  }
}
