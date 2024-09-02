//
//  APIResponseModel.swift
//  BeTime
//
//  Created by 쭌이 on 8/26/24.
//

import Foundation

struct Response<ItemType: Decodable>: Decodable {
  let header: Header
  let body: Body<ItemType>
}

struct Header: Decodable {
  let resultCode: String
  let resultMessage: String

  enum CodingKeys: String, CodingKey {
    case resultCode = "resultCode"
    case resultMessage = "resultMsg"
  }
}

struct Body<ItemType: Decodable>: Decodable {
  let dataType: String
  let items: Item<ItemType>
  let pageNo: Int
  let numOfRows: Int
  let totalCount: Int
}

struct Item<ItemType: Decodable>: Decodable {
  let item: [ItemType]
}
