//
//  AlertModel.swift
//  BeTime
//
//  Created by 쭌이 on 10/8/24.
//

import UIKit

struct AlertModel {
  var title: String
  var message: String
  var cancelTitle: String = "취소"
  var okTitle: String = "OK"
  var okAction: (() -> Void)? = nil

  func createAlert() -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
    let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
      self.okAction?()
    }
    alert.addAction(cancelAction)
    alert.addAction(okAction)
    return alert
  }
}
