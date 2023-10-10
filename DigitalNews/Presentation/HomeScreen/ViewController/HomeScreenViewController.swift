//
//  ViewController.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import UIKit

final class HomeScreenViewController: UIViewController {
    
    @IBOutlet private weak var customNavigationBarView: CustomNavigationBarView!
    @IBOutlet private weak var newsListTableView: UITableView!
    
    private let homeScreenViewModel = HomeScreenViewModel(newsRepository: NewsRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsListTableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
    
    
}
