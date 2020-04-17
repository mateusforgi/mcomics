//
//  MarvelAPIEnvironment.swift
//  MComics
//
//  Created by Mateus Forgiarini on 4/14/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import Foundation

struct MarvelAPIEnvironment {
    
    // MARK: - Variables
    private let infoPlistEnvironment = InfoPlistEnvironment()
    
    // MARK: - Private Methods
    private var endPointDict: NSDictionary? {
        var dict: NSDictionary?
        if let path = Bundle.main.path(forResource: "MarvelEndpoints", ofType: "plist") {
            dict = NSDictionary(contentsOfFile: path)
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }
    
    private func getCredentialsQueryString(url: String) -> String? {
        guard let tsValue = infoPlistEnvironment.getInfoPlistVariable(plistKey: .ts) else {
            return url
        }
        guard let hashValue = infoPlistEnvironment.getInfoPlistVariable(plistKey: .hash) else {
            return url
        }
        guard let apiKey = infoPlistEnvironment.getInfoPlistVariable(plistKey: .apiKey) else {
            return url
        }
        return "\(url)?ts=\(tsValue)&apikey=\(apiKey)&hash=\(hashValue)"
    }
    
    private func replaceParameters(url: inout String, parameters: [EndpointParameters: String]) {
        for parameter in parameters {
            url = url.replacingOccurrences(of: parameter.key.rawValue, with: parameter.value)
        }
    }
    
    // MARK: - Public Methods
    public func getUrlFrom(endPoint: EndpointPlistKey, parameters: [EndpointParameters: String]?, queryStrings: [MarvelQueryStringParameter: String]?) -> String? {
        guard let baseURL = infoPlistEnvironment.getInfoPlistVariable(plistKey: .apiURL), let endPoint = endPointDict?[endPoint.rawValue] as? String else {
            return nil
        }
        var url = baseURL + endPoint
        if let parameters = parameters {
            replaceParameters(url: &url, parameters: parameters)
        }
        let urlWithKeys = getCredentialsQueryString(url: url)
        guard let queryStrings = queryStrings else {
            return urlWithKeys
        }
        return addQueryStrings(url: urlWithKeys ?? "", queryStrings: queryStrings)
    }
    
    private func addQueryStrings(url: String, queryStrings: [MarvelQueryStringParameter: String]) -> String {
        var urlCopy = url
        for queryString in queryStrings {
            urlCopy += "&\(queryString.key.rawValue)=\(queryString.value)"
        }
        return urlCopy
    }
    
    public static func getPhotoURL(path: String, imageExtension: String, size: MarvelImageSize) -> String {
        return  "\(path)/\(size.rawValue).\(imageExtension)".replacingOccurrences(of: "http", with: "https")
    }
    
}
