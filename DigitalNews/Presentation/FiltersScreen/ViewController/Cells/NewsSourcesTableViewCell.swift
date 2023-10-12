//
//  NewsSourcesTableViewCell.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 12.10.2023.
//

import UIKit

class NewsSourcesTableViewCell: UITableViewCell {
    static let id = "\(NewsSourcesTableViewCell.self)"
    
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var isSelectedImageView: UIImageView!
    
    func config(from model: String) {
        sourceLabel.text = model
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        isSelectedImageView.image = selected ? UIImage(systemName: "checkmark") : nil
    }
    
}
