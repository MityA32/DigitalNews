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
    @IBOutlet weak var isFavouriteImageView: UIImageView!
    
    weak var addDelegate: AddFavouritePieceOfNewsDelegate?
    weak var removeDelegate: RemoveFavouritePieceOfNewsDelegate?
    weak var favouriteScreenDelegate: FavouriteNewsScreenDelegate?
    var pieceOfNewsModel: PieceOfNewsModel?
    var pieceOfNews: PieceOfNews?
    
    func config(from model: PieceOfNewsModel) {
        pieceOfNewsModel = model
        guard let pieceOfNewsModel else { return }
        let tapOnStar = UITapGestureRecognizer(target: self, action: #selector(tappedOnStar))
        isFavouriteImageView.addGestureRecognizer(tapOnStar)
        isFavouriteImageView.isUserInteractionEnabled = true
        isFavouriteImageView.image = UIImage(systemName: pieceOfNewsModel.isFavourite ? "star.fill" : "star")
        pieceOfNewsImageView.image = UIImage(named: "icon_news_placeholder")
        titleLabel.text = pieceOfNewsModel.title ?? "Untitled"
        dateLabel.text = pieceOfNewsModel.publishedAt?.formattedFromISO8601() ?? "--"
        authorLabel.text = pieceOfNewsModel.author ?? "unknown author"
        sourceLabel.text = pieceOfNewsModel.source?.name ?? "unknown source"
        descriptionLabel.text = pieceOfNewsModel.description ?? "No description"
        guard let urlToImage = pieceOfNewsModel.urlToImage else { return }
        DispatchQueue.main.async { [weak self] in
            self?.pieceOfNewsImageView.sd_setImage(
                with: URL(string: urlToImage),
                placeholderImage: UIImage(named: "icon_news_placeholder")
            )
        }
    }
    
    func configFavourite(from model: PieceOfNews) {
        pieceOfNews = model
        guard let pieceOfNews else { return }
        let tapOnStar = UITapGestureRecognizer(target: self, action: #selector(tappedOnFavouriteStar))
        isFavouriteImageView.addGestureRecognizer(tapOnStar)
        isFavouriteImageView.isUserInteractionEnabled = true
        isFavouriteImageView.image = UIImage(systemName: "star.fill")
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
    
    @objc func tappedOnStar() {
        guard let pieceOfNewsModel else { return }
        pieceOfNewsModel.isFavourite ? removeDelegate?.removeFavourite(pieceOfNewsModel) : addDelegate?.addFavourite(pieceOfNewsModel)
        self.pieceOfNewsModel?.isFavourite.toggle()
        isFavouriteImageView.image = UIImage(systemName: self.pieceOfNewsModel?.isFavourite ?? false ? "star.fill" : "star")
    }
    
    @objc func tappedOnFavouriteStar() {
        guard let pieceOfNews else { return }
        favouriteScreenDelegate?.remove(pieceOfNews)
    }
    
}
