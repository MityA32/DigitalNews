//
//  NewsListTableViewCell.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import UIKit

final class NewsListTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pieceOfNewsImageView: UIImageView!
    
    func config(from model: PieceOfNews) {
        titleLabel.text = model.title ?? "Untitled"
        dateLabel.text = ""
    }
    
    
}
