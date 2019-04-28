//
//  StocksTableViewController.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa
import SnapKit

class StocksTableViewController: NSViewController {

    private var scrollView: NSScrollView!
    
    private var headerView: StockHeaderView!
    
    private var tableView: NSTableView!
    
    private var footerView: StockFooterView!
    
    private let symbolHeaderCell = NSTableHeaderCell(textCell: "股票名称")
    private let priceHeaderCell = NSTableHeaderCell(textCell: "价格")
    private let percentHeaderCell = NSTableHeaderCell(textCell: "涨跌幅")
    
    internal let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "StockTableViewCellIdentifier")
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 280, height: 450))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        setupTableView()
        setupFooterView()
        StockDataSource.shared.updatedHandler = { [weak self] in
            self?.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    private func setupHeaderView() {
        headerView = StockHeaderView(frame: NSRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setupTableView() {
        scrollView = NSScrollView(frame: view.bounds)
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .noBorder
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        tableView = NSTableView()
        tableView.backgroundColor = .white
        tableView.register(NSNib(nibNamed: "StockTableCellView", bundle: nil), forIdentifier: reuseIdentifier)
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
        
        let menu = NSMenu()
        menu.delegate = self
        tableView.menu = menu
        view.window?.makeFirstResponder(tableView)
    }
    
    private func setupFooterView() {
        footerView = StockFooterView(frame: NSRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        view.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

extension StocksTableViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return StockDataSource.shared.numberOfRows()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let stock = StockDataSource.shared.data(atIndex: row)
        if let cell = tableView.makeView(withIdentifier: reuseIdentifier, owner: self) as? StockTableCellView {
            cell.update(stock)
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }
}

extension StocksTableViewController: NSMenuDelegate {
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        
        menu.addItem(NSMenuItem(title: "Delete", action: #selector(handleDeleteRow), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Top", action: #selector(handleTopRow), keyEquivalent: ""))
    }
    
    @objc private func handleDeleteRow() {
        
    }
    
    @objc private func handleTopRow() {
        
    }
}
