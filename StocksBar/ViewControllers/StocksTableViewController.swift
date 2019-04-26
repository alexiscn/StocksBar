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
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDataSource()
        
        
    }
    
    private func setupTableView() {
        tableView = NSTableView(frame: view.bounds)
        tableView.autoresizingMask = [.width, .height]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        //let header = NSTableHeaderView(frame: NSRect(x: 0, y: 0, width: view.bounds.height, height: 24))
        
    }
    
    private func setupDataSource() {
        
    }
}

extension StocksTableViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
//        tableColumn?.headerCell =
        
        return nil
    }
    
}
