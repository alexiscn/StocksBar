//
//  StockSearchViewController.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockSearchViewController: NSViewController {

    private var scrollView: NSScrollView!
    var tableView: NSTableView!
    
    let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "StockSearchViewCellIdentifier")
    
    private var dataSource: [Stock] = []
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        scrollView = NSScrollView(frame: .zero)
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .noBorder
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        tableView = NSTableView()
        tableView.backgroundColor = NSColor(white: 1, alpha: 0.6)
        tableView.register(NSNib(nibNamed: "StockSearchCellView", bundle: nil), forIdentifier: reuseIdentifier)
        tableView.selectionHighlightStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.floatsGroupRows = true
        tableView.intercellSpacing = NSSize.zero

        scrollView.documentView = tableView

        let column = NSTableColumn()
        column.width = view.bounds.width
        tableView.headerView = nil
        tableView.addTableColumn(column)
    }
    
    func updateDataSource(_ dataSource: [Stock]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }
}

extension StockSearchViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let stock = dataSource[row]
        if let cell = tableView.makeView(withIdentifier: reuseIdentifier, owner: self) as? StockSearchCellView {
            cell.update(stock)
            cell.favoriteButtonHandler = { [weak self] in
                if stock.isFavorited {
                    stock.isFavorited = false
                    StockDataSource.shared.remove(stock: stock)
                } else {
                    stock.isFavorited = true
                    StockDataSource.shared.add(stock: stock)
                }
                self?.tableView.reloadData()
            }
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
}
