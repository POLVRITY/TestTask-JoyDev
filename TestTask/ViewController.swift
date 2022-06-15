//
//  ViewController.swift
//  TestTask
//
//  Created by Vladislav on 24.05.2022.
//

import UIKit
import Moya
import CoreData

struct LocalBooksModel {
    var title: String?
    var description: String?
    var isHidden = false
    
    init(book: BooksModel) {
        self.title = book.title
        self.description = book.description
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Objects
    private let booksService = BooksService()
    private let tableView = UITableView()
    private var dataBaseHelper = DataBaseHelper()
    private var localBooks = [LocalBooksModel]()
    // Arrays
    private var books = [BooksModel]()
    // Flags
    private var isAvailableBooks = true
    private var isOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBooks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return localBooks.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if localBooks[section].isHidden {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: BookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell ?? BookCell()
            cell.configureTitle(title: localBooks[indexPath.section].title ?? "")
            return cell
        } else {
            let cell: BookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell ?? BookCell()
            cell.configureDescription(description: localBooks[indexPath.section].description ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            if localBooks[indexPath.section].isHidden {
                localBooks[indexPath.section].isHidden = false
                let sections = IndexSet.init(integer: indexPath.section)
                
                tableView.reloadSections(sections, with: .none)
            } else {
                localBooks[indexPath.section].isHidden = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == localBooks.count - 1, isAvailableBooks else {
            return
        }
        Constants.numOfPage += 1
        loadBooks()
    }
    
    private func loadBooks() {
        booksService.loadBooks(numOfPage: Constants.numOfPage, itemPerPage: Constants.itemsPerPage) { [weak self] result in
            switch result {
            case .success(let books):
                guard let self = self, let books = books, self.isAvailableBooks else { return }
                self.books.append(contentsOf: books)
                
                self.localBooks += books.map {
                    LocalBooksModel(book: $0)
                }
                
                self.tableView.reloadData()
                
                if books.isEmpty {
                    self.isAvailableBooks = false
                }
                
                books.forEach { book in
                    self.dataBaseHelper.saveBookInDataBase(with: book)
                }
            case .failure(_):
                self?.loadBooksDB()
            }
        }
    }
    
    private func loadBooksDB() {
        let tempBooks = dataBaseHelper.fetchBooks()
        if tempBooks.isEmpty {
            isAvailableBooks = false
        } else {
            localBooks += tempBooks.map {
                LocalBooksModel(book: $0)
            }
            tableView.reloadData()
        }
    }
}
