//
//  URLRequestExtension.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

extension URLRequest {
  
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    init(url: URL, method: HTTPMethod) throws {
        self.init(url: url)
        httpMethod = method.rawValue
    }
    
}
