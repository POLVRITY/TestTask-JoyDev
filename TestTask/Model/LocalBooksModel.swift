//
//  LocalBooksModel.swift
//  TestTask
//
//  Created by Vladislav on 15.06.2022.
//

import Foundation

struct LocalBooksModel {
    var title: String?
    var description: String?
    var isHidden = false
    
    init(book: BooksModel) {
        self.title = book.title
        self.description = book.description
    }
}
