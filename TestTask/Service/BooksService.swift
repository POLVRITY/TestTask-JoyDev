//
//  BooksService.swift
//  TestTask
//
//  Created by Vladislav on 24.05.2022.
//

import Foundation
import Moya

struct BooksModel: Decodable {
    var title: String?
    var description: String?
}

class BooksService {
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var provider = MoyaProvider<TargetBook>()
    
    func loadBooks(numOfPage: Int, itemPerPage: Int, complition: @escaping (Result<[BooksModel]?, Error>) -> Void) {
    provider.request(.books(page: numOfPage, itemsPerPage: itemPerPage)) { (result) in
        switch result {
        case .success(let response):
            let book:[BooksModel]? = try? JSONDecoder().decode([BooksModel].self, from: response.data)
            complition(.success(book))
        case .failure(let error):
                print(error.errorDescription ?? "Fatal error")
            complition(.failure(error))
        }
        }
    }
}
