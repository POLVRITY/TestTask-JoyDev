//
//  DataBaseHelper.swift
//  TestTask
//
//  Created by Vladislav on 03.06.2022.
//

import Foundation
import CoreData
import UIKit

class DataBaseHelper {
    // Flags
    var isBooksDeleted = false
    
    private var offSet = 0
    
    func fetchBooks() -> [BooksModel] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest = BooksDataBase.fetchRequest()
        fetchRequest.fetchLimit = Constants.itemsPerPage
        fetchRequest.fetchOffset = offSet
        
        do {
            let request = try context.fetch(fetchRequest)
            offSet += Constants.itemsPerPage
            let books = request.map { book -> BooksModel in
                return BooksModel(title: book.title, description: book.text)
            }            
            return books
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return []
    }
    
    func saveBookInDataBase(with book: BooksModel) {
        if(!isBooksDeleted) {
            deleteBooks()
            isBooksDeleted = true
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "BooksDataBase", in: context) else {return}
        
        let taskObject = BooksDataBase(entity: entity, insertInto: context)
        taskObject.title = book.title
        taskObject.text = book.description
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    func deleteBooks() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BooksDataBase> = BooksDataBase.fetchRequest()
        
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
