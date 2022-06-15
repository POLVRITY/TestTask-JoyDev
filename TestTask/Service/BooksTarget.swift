//
//  MyService.swift
//  TestTask
//
//  Created by Vladislav on 24.05.2022.
//

import Foundation
import Moya

enum TargetBook {
    case books(page: Int, itemsPerPage: Int)
}

extension TargetBook: TargetType {
    
    var baseURL: URL {
        URL(string: "https://demo.api-platform.com")!
    }
    
    var path: String {
        switch self {
        case .books(_, _):
            return "/books"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .books(let page, let itemsPerPage):
            return .requestParameters(parameters: ["page": page, "itemsPerPage": itemsPerPage], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["accept": "application/json"]
    }
}
