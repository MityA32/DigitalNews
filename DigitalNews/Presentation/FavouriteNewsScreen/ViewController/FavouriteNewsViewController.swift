//
//  FavouriteNewsViewController.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 12.10.2023.
//

import UIKit

final class FavouriteNewsViewController: UIViewController {

    
    @IBOutlet private weak var favouriteNewsTableView: UITableView!
    
    private let nothingWasFoundLabel = UILabel()
    
    weak var delegate: FavouriteNewsScreenDelegate?
    var favouriteNews: [PieceOfNews] = [] {
        didSet {
            nothingWasFoundLabel.isHidden = !favouriteNews.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "Favourites"
        setupTableView()
        setupEmptyTableViewPlaceholder()
    }

    private func setupTableView() {
        favouriteNewsTableView.delegate = self
        favouriteNewsTableView.dataSource = self
        favouriteNewsTableView.registerCell(NewsListTableViewCell.self)
        favouriteNewsTableView.separatorStyle = .none
    }
    
    private func setupEmptyTableViewPlaceholder() {
        nothingWasFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingWasFoundLabel.text = "No favourite news"
        nothingWasFoundLabel.textAlignment = .center
        nothingWasFoundLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nothingWasFoundLabel.numberOfLines = 0
        nothingWasFoundLabel.isHidden = !favouriteNews.isEmpty
        favouriteNewsTableView.addSubview(nothingWasFoundLabel)
        
        NSLayoutConstraint.activate([
            nothingWasFoundLabel.centerXAnchor.constraint(equalTo: favouriteNewsTableView.centerXAnchor),
            nothingWasFoundLabel.centerYAnchor.constraint(equalTo: favouriteNewsTableView.centerYAnchor),
            nothingWasFoundLabel.widthAnchor.constraint(equalTo: favouriteNewsTableView.widthAnchor, multiplier: 0.8),
            nothingWasFoundLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}

extension FavouriteNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteNewsTableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.id, for: indexPath) as! NewsListTableViewCell
        cell.selectionStyle = .none
        cell.favouriteScreenDelegate = self
        cell.configFavourite(from: favouriteNews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = PieceOfNewsWebViewController.instantiateFromNib()
        webViewController.url = favouriteNews[indexPath.row].url
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension FavouriteNewsViewController: FavouriteNewsScreenDelegate {
    func remove(_ pieceOfNews: PieceOfNews) {
        delegate?.remove(pieceOfNews)
        if let index = favouriteNews.firstIndex(where: { $0 == pieceOfNews }) {
            favouriteNews.remove(at: index)
            favouriteNewsTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
            nothingWasFoundLabel.isHidden = !favouriteNews.isEmpty
        }
    }
}
