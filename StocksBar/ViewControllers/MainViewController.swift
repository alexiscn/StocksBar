//
//  MainViewController.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    private var headerView: StockHeaderView!
    
    private var containerView: NSView!
    
    private var footerView: StockFooterView!
    
    private let throttler = Throttler(seconds: 0.3)
    
    private lazy var stocksViewController: StocksTableViewController = {
        let controller = StocksTableViewController()
        return controller
    }()
    
    private lazy var searchViewController: StockSearchViewController = {
        let controller = StockSearchViewController()
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupEffectView()
        setupHeaderView()
        setupContainerView()
        setupFooterView()
        addStocksViewController()
        addSearchViewController()
        
        StockDataSource.shared.updatedHandler = {
            self.stocksViewController.reloadData()
            let stock = StockDataSource.shared.data(atIndex: 0)
            self.footerView.update(stock: stock)
        }
    }
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 450))
    }
    
    private func setupEffectView() {
        let effectView = NSVisualEffectView(frame: view.bounds)
        effectView.material = .menu
        view.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupHeaderView() {
        headerView = StockHeaderView(frame: NSRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        headerView.headerCommand = { [weak self] in
            self?.stocksViewController.editTableView()
        }
        headerView.searchField.delegate = self
    }
    
    private func setupContainerView() {
        containerView = NSView(frame: NSRect(x: 0, y: 50, width: 300, height: 350))
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private func setupFooterView() {
        footerView = StockFooterView(frame: NSRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        view.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func addStocksViewController() {
        addChild(stocksViewController)
        stocksViewController.view.frame = containerView.bounds
        containerView.addSubview(stocksViewController.view)
    }
    
    private func addSearchViewController() {
        addChild(searchViewController)
        searchViewController.view.frame = containerView.bounds
        containerView.addSubview(searchViewController.view)
        searchViewController.view.isHidden = true
    }
    
    private func doSearch(key: String) {
        if key.count == 0 {
            searchViewController.view.isHidden = true
            stocksViewController.view.isHidden = false
        } else {
            stocksViewController.view.isHidden = true
            searchViewController.view.isHidden = false
            StockDataSource.shared.search(suggestion: key) { (stocks, error) in
                self.searchViewController.updateDataSource(stocks)
            }
        }
    }
}

extension MainViewController: NSSearchFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else {
            return
        }
        
        throttler.throttle {
            DispatchQueue.main.async {
                self.doSearch(key: textField.stringValue)
            }
        }
    }
    
}
