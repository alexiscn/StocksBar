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
    private var tableView: NSTableView!
    
    let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "StockSearchViewCellIdentifier")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        scrollView = NSScrollView(frame: .zero)
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.drawsBackground = false
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .noBorder
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }

        tableView = NSTableView()
        tableView.backgroundColor = .clear
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
}

extension StockSearchViewController: NSTableViewDataSource, NSTableViewDelegate {
    
}