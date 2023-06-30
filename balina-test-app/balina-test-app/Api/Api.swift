//
//  Api.swift
//  balina-test-app
//
//  Created by Bahdan Piatrouski on 30.06.23.
//

import UIKit
import Moya
import Alamofire

enum Api {
    case getCategories(page: Int)
    case sendPhoto(id: Int, photo: UIImage)
}

extension Api: TargetType {
    var baseURL: URL {
        return URL(string: "https://junior.balinasoft.com/api/v2")!
    }
    
    var path: String {
        switch self {
            case .getCategories:
                return "/photo/type"
            case .sendPhoto:
                return "/photo"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getCategories:
                return .get
            case .sendPhoto:
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
            case .getCategories:
                guard let parameters else { return .requestPlain }
                
                return .requestParameters(parameters: parameters, encoding: encoding)
            case .sendPhoto(let id, let photo):
                guard let photoData = photo.pngData(),
                      let idData = "\(id)".data(using: .utf8),
                      let nameData = "Петровский Богдан Сергеевич".data(using: .utf8)
                else { return .requestPlain }
                
                let photoMultipartData = MultipartFormData(provider: .data(photoData), name: "photo", fileName: "\(Int(round(Date().timeIntervalSince1970))).png", mimeType: "image/png")
                let idMultipartData = MultipartFormData(provider: .data(idData), name: "typeId")
                let nameMultipartData = MultipartFormData(provider: .data(nameData), name: "name")
                
                return .uploadMultipart([photoMultipartData, idMultipartData, nameMultipartData])
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        var parameters = [String: Any]()
        switch self {
            case .getCategories(let page):
                parameters["page"] = page
            default:
                return nil
        }
        
        return parameters
    }
    
    var encoding: URLEncoding {
        return .queryString
    }
}
