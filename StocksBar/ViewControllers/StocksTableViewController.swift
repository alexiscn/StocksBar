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

    private var tableView: NSTableView!
    
    private var dataSource: [Stock] = []
    
    private let symbolHeaderCell = NSTableHeaderCell(textCell: "股票名称")
    private let priceHeaderCell = NSTableHeaderCell(textCell: "价格")
    private let percentHeaderCell = NSTableHeaderCell(textCell: "涨跌幅")
    
    internal let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "StockTableViewCellIdentifier")
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 600))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDataSource()
        tableView.reloadData()
        
    }
    
    private func setupTableView() {
        tableView = NSTableView(frame: view.bounds)
        tableView.register(NSNib(nibNamed: "StockTableCellView", bundle: nil), forIdentifier: reuseIdentifier)
        tableView.gridColor = NSColor(white: 232.0/254, alpha: 1.0)
        tableView.gridStyleMask = .solidHorizontalGridLineMask
        tableView.autoresizingMask = [.width, .height]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        let column = NSTableColumn()
        column.width = view.bounds.width
        tableView.headerView = nil
        tableView.addTableColumn(column)
    }
    
    private func setupDataSource() {
        dataSource.append(Stock(code: "sh601933"))
        dataSource.append(Stock(code: "sz000651"))
        dataSource.append(Stock(code: "sh601933"))
        dataSource.append(Stock(code: "sz000651"))
        dataSource.append(Stock(code: "sh601933"))
        dataSource.append(Stock(code: "sz000651"))
        dataSource.append(Stock(code: "sh601933"))
        dataSource.append(Stock(code: "sz000651"))
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
        let stock = dataSource[row]
        if let cell = tableView.makeView(withIdentifier: reuseIdentifier, owner: self) as? StockTableCellView {
            cell.update(stock)
            return cell
        }
        return nil
    }
    
}
