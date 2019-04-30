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
    
    internal let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "StockTableViewCellIdentifier")
    
    private var isEditing = false
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 450))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEffectView()
        setupHeaderView()
        setupTableView()
        setupFooterView()
        StockDataSource.shared.updatedHandler = {
            if !self.isEditing {
                self.tableView.reloadData()
                let stock = StockDataSource.shared.data(atIndex: 0)
                self.footerView.update(stock: stock)
            }
        }
        tableView.reloadData()
    }
    
    private func editTableView() {
        isEditing = !isEditing
        
        for i in 0 ..< self.tableView.numberOfRows {
            let cell = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: true) as! StockTableCellView
            isEditing ? cell.beginEditing(): cell.endEditing()
        }
        tableView.reloadData()
    }
    
    private func setupEffectView() {
        let effectView = NSVisualEffectView(frame: view.bounds)
        effectView.material = .menu
        view.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.bottom.trailing.equalToSuperview()
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
            self?.editTableView()
        }
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
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        tableView = NSTableView()
        tableView.backgroundColor = NSColor(white: 1, alpha: 0.3)
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
    
    private func removeRow(_ row: Int, stock: Stock) {
        let cell = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? StockTableCellView
        cell?.endEditing()
        tableView.removeRows(at: IndexSet(arrayLiteral: row), withAnimation: .effectFade)
        StockDataSource.shared.remove(stock: stock)
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
            cell.deleteCommand = { [weak self] in
                self?.removeRow(row, stock: stock)
            }
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
        let clickedRow = tableView.clickedRow
        if clickedRow > 0 {
            StockDataSource.shared.stickToTop(at: clickedRow)
        }
    }
}
