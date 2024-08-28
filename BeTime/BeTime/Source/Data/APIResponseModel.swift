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
  let resultMsg: String
}

struct Body<ItemType: Decodable>: Decodable {
  let dataType: String
  let items: [ItemType]
  let pageNo: Int
  let numOfRows: Int
  let totalCount: Int
}
