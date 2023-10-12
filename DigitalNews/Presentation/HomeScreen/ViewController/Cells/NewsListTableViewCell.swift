//
//  NewsListTableViewCell.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import UIKit
import SDWebImage

final class NewsListTableViewCell: UITableViewCell {
    
    static let id = "\(NewsListTableViewCell.self)"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pieceOfNewsImageView: UIImageView!
    
    func config(from model: PieceOfNewsModel) {
        pieceOfNewsImageView.image = UIImage(named: "icon_news_placeholder")
        titleLabel.text = model.title ?? "Untitled"
        dateLabel.text = model.publishedAt?.formattedFromISO8601() ?? "--"
        authorLabel.text = model.author ?? "unknown author"
        sourceLabel.text = model.source?.name ?? "unknown source"
        descriptionLabel.text = model.description ?? "No description"
        guard let urlToImage = model.urlToImage else { return }
        DispatchQueue.main.async { [weak self] in
            self?.pieceOfNewsImageView.sd_setImage(
                with: URL(string: urlToImage),
                placeholderImage: UIImage(named: "icon_news_placeholder")
            )

        }
    }
    
    func configSaved(from model: PieceOfNews) {
        pieceOfNewsImageView.image = UIImage(named: "icon_news_placeholder")
        titleLabel.text = model.title ?? "Untitled"
        dateLabel.text = model.publishedAt ?? "--"
        authorLabel.text = model.author ?? "unknown author"
        sourceLabel.text = model.source ?? "unknown source"
        descriptionLabel.text = model.newsDescription ?? "No description"
        guard let urlToImage = model.urlToImage else { return }
        DispatchQueue.main.async { [weak self] in
            self?.pieceOfNewsImageView.sd_setImage(
                with: urlToImage,
                placeholderImage: UIImage(named: "icon_news_placeholder")
            )
        }
    }
}
