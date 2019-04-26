//
//  StocksTableViewController.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StocksTableViewController: NSViewController {

    private var tableView: NSTableView!
    
    private var dataSource: [Stock] = []
    
    private let symbolHeaderCell = NSTableHeaderCell(textCell: "股票名称")
    private let priceHeaderCell = NSTableHeaderCell(textCell: "价格")
    private let percentHeaderCell = NSTableHeaderCell(textCell: "涨跌幅")
    
    private struct CellIdentifiers {
        static let symbols = "SymbolCellID"
        static let price = "PriceCellID"
        static let percent = "PercentCellID"
    }
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 500))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDataSource()
        tableView.reloadData()
        
    }
    
    private func setupTableView() {
        tableView = NSTableView(frame: view.bounds)
        tableView.autoresizingMask = [.width, .height]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        dataSource.append(Stock(code: "sh601933"))
        dataSource.append(Stock(code: "sz000651"))
    }
}

extension StocksTableViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        tableColumn?.headerCell =
        if tableColumn == tableView.tableColumns.first {
            
        }
        tableColumn?.headerCell = symbolHeaderCell
        return NSView()
    }
    
}
