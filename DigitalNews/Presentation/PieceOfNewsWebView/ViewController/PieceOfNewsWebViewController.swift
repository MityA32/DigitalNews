//
//  PieceOfNewsWebViewController.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import UIKit
import WebKit

class PieceOfNewsWebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    let activityIndicator = UIActivityIndicatorView()
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupActivityIndicator()
    }

    private func setup() {
        title = "Source"
        navigationController?.isNavigationBarHidden = false
        webView.navigationDelegate = self
        guard let url else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
}

extension PieceOfNewsWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
