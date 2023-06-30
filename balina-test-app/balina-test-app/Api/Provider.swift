//
//  Provider.swift
//  balina-test-app
//
//  Created by Bahdan Piatrouski on 30.06.23.
//

import UIKit
import Moya
import Moya_ObjectMapper

final class Provider {
    static let standard = Provider()
    
    private let provider = MoyaProvider<Api>()
    
    func getPhotos(page: Int = 0, success: @escaping((PhotosResponseModel) -> ()), failure: @escaping(() -> ())) {
        provider.request(.getCategories(page: page)) { result in
            switch result {
                case .success(let response):
                    guard let photos = try? response.mapObject(PhotosResponseModel.self) else {
                        failure()
                        return
                    }
                    
                    success(photos)
                case .failure:
                    failure()
                    return
            }
        }
    }
    
    func uploadPhoto(id: Int, photo: UIImage, success: @escaping(() -> ()), failure: @escaping(() -> ())) {
        provider.request(.sendPhoto(id: id, photo: photo)) { result in
            switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        success()
                    } else {
                        failure()
                    }
                case .failure:
                    failure()
                    return
            }
        }
    }
}
