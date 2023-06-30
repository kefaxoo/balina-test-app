//
//  PhotosResponseModel.swift
//  balina-test-app
//
//  Created by Bahdan Piatrouski on 30.06.23.
//

import Foundation
import ObjectMapper

final class PhotosResponseModel: Mappable {
    var page = 0
    var totalPage = 0
    var photos: [PhotoTypeResponseModel]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        page      <- map["page"]
        totalPage <- map["totalPages"]
        photos    <- map["content"]
    }
}

final class PhotoTypeResponseModel: Mappable {
    var id = 0
    var name = ""
    var image: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        name  <- map["name"]
        image <- map["image"]
    }
}
