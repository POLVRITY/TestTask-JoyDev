//
//  TableCell.swift
//  TestTask
//
//  Created by Vladislav on 25.05.2022.
//

import Foundation
import SnapKit

class BookCell: UITableViewCell {
    private var bookTitleView = UILabel()
    private var bookDescriptionView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configTitleView()
        setupTitle()
        setupDescription()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal error")
    }
    
    func configureTitle(title: String) {
        bookTitleView.text = "Название книги: \(title)"
    }
    
    func configureDescription(description: String) {
        bookDescriptionView.text = "Описание книги: \(description)"
    }
    
    override func prepareForReuse() {
        bookTitleView.text = ""
        bookDescriptionView.text = ""
        
    }
    
    func configTitleView() {
        contentView.addSubview(bookTitleView)
        contentView.addSubview(bookDescriptionView)
        
        bookTitleView.numberOfLines = 0
        bookTitleView.adjustsFontSizeToFitWidth = true
        bookTitleView.backgroundColor = UIColor.white
        bookTitleView.textColor = UIColor.blue
        
        bookDescriptionView.numberOfLines = 0
        bookDescriptionView.adjustsFontSizeToFitWidth = true
        bookDescriptionView.textColor = UIColor.red
        
    }
    
    func setupTitle() {
        bookTitleView.translatesAutoresizingMaskIntoConstraints = false
        bookTitleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setupDescription() {
        bookDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        bookDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
