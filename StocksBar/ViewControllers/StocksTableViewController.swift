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
    
    private var tableView: NSTableView!
    
    let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "StockTableViewCellIdentifier")
    
    let dragType = NSPasteboard.PasteboardType("stock.public.data")
    
    private var isEditing = false
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
        tableView.reloadData()
    }
    
    func reloadData() {
        if !isEditing {
            tableView.reloadData()
        }
    }
    
    func editTableView() {
        isEditing = !isEditing
        
        for i in 0 ..< self.tableView.numberOfRows {
            let cell = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: true) as! StockTableCellView
            isEditing ? cell.beginEditing(): cell.endEditing()
        }
        tableView.reloadData()
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
        tableView.rowHeight = 40.0
        tableView.backgroundColor = NSColor(white: 1, alpha: 0.6)
        tableView.register(NSNib(nibNamed: "StockTableCellView", bundle: nil), forIdentifier: reuseIdentifier)
        tableView.selectionHighlightStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.floatsGroupRows = true
        tableView.intercellSpacing = NSSize.zero
        tableView.registerForDraggedTypes([dragType])
        tableView.draggingDestinationFeedbackStyle = .gap
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
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        let item = NSPasteboardItem()
        item.setData(data, forType: dragType)
        pboard.writeObjects([item])
        return true
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        guard let source = info.draggingSource as? NSTableView, source == tableView else {
            return []
        }
        if dropOperation == .above || dropOperation == .on {
            return .move
        }
        return []
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        let pb = info.draggingPasteboard
        if let itemData = pb.pasteboardItems?.first?.data(forType: dragType),
            let indexes = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? IndexSet {
            for index in indexes {
                StockDataSource.shared.move(from: index, to: row)
                tableView.moveRow(at: index, to: row)
            }
            return true
        }
        return false
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        isEditing = false
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
        isEditing = true
    }
}

extension StocksTableViewController: NSMenuDelegate {
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        menu.addItem(NSMenuItem(title: "置顶", action: #selector(handleTopRow), keyEquivalent: ""))
        //menu.addItem(NSMenuItem(title: "删除", action: #selector(handleDeleteRow), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "提醒", action: #selector(priceReminder), keyEquivalent: ""))
        
        let deleteText = NSAttributedString(string: "删除", attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.red
        ])
        let deleteItem = NSMenuItem()
        deleteItem.attributedTitle = deleteText
        deleteItem.action = #selector(handleDeleteRow)
        menu.addItem(deleteItem)
    }
    
    @objc private func handleDeleteRow() {
        let clickedRow = tableView.clickedRow
        if clickedRow >= 0 {
            StockDataSource.shared.remove(at: clickedRow)
        }
    }
    
    @objc private func handleTopRow() {
        let clickedRow = tableView.clickedRow
        if clickedRow >= 0 {
            StockDataSource.shared.stickToTop(at: clickedRow)
        }
    }
    
    @objc private func priceReminder() {
        let clickedRow = tableView.clickedRow
        if clickedRow >= 0 {
            let stock = StockDataSource.shared.data(atIndex: clickedRow)
            let window = NSStoryboard.main.instantiateViewController(ofType: StockRemindWinowController.self)
            let controller = window.contentViewController as! StockRemindViewController
            controller.closeCommand = {
                window.close()
            }
            controller.update(stock: stock)
            window.showWindow(self)
        }
    }
}
