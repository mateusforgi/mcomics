//
//  NetworkManager.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation
import Combine

protocol  NetworkManager {
    var session: URLSession { get }
}

extension NetworkManager {
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { $0 }
            .eraseToAnyPublisher()
        
    }
    
    func get<T>(url: URL) -> AnyPublisher<T, Error> where T: Decodable  {
        
        guard let request = try? URLRequest(url: url, method: .get) else {
            let error = NetworkError.invalidURL
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { $0 }
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
}

