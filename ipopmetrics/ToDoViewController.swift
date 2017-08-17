//
//  ToDoViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController
import SwiftyJSON

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections: [TodoSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        registerCellsForTable()

        setUpNavigationBar()
        
        fetchItemsLocally()
    }
    
    internal func registerCellsForTable() {
        let calendarCardNib = UINib(nibName: "CalendarCard", bundle: nil)
        tableView.register(calendarCardNib, forCellReuseIdentifier: "CalendarCard")
        
        let calendarCardSimpleNib = UINib(nibName: "CalendarCardSimple", bundle: nil)
        tableView.register(calendarCardSimpleNib, forCellReuseIdentifier: "CalendarCardSimple")
        
        let toDoHeaderCardNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(toDoHeaderCardNib, forCellReuseIdentifier: "headerCardCell")
        tableView.register(TableFooterView.self, forHeaderFooterViewReuseIdentifier: "footerId")
        
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "To Do", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.regular, size: 18)
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func handlerClickMenu() {
        
    }
    
    internal func fetchItemsLocally() {
        let path = Bundle.main.path(forResource: "sampleFeedTodo", ofType: "json")
        let jsonData: NSData = NSData(contentsOfFile: path!)!
        let json = JSON(data: jsonData as Data)
        let todoStore = TodoStore.getInstance()
        for item in json["items"] {
            let todoItem = TodoItem()
            todoItem.status = item.1["status"].description
            todoItem.articleTitle = item.1["article_title"].description
            todoItem.statusDate = Date(timeIntervalSince1970: Double(item.1["status_date"].description)!)
            todoItem.articleImage = item.1["article_image"].description
            todoItem.articleText = item.1["article_text"].description
            todoItem.type = item.1["type"].description
            todoItem.articleUrl = item.1["article_url"].description
            todoItem.articleCategory = item.1["article_category"].description
            print(Double(item.1["status_date"].description));
            //calendarItem.articleCategory
            print(item.1["status"].description)
            //calendarFeedStore.app
            todoStore.storeItem(item: todoItem)
        }
        
        self.sections = todoStore.getFeed()
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCard", for: indexPath) as! CalendarCardViewCell
            cell.topToolbar.backgroundColor = PopmetricsColor.yellowUnapproved
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCardSimple", for: indexPath) as! CalendarCardSimpleViewCell

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let toDoHeader = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
        toDoHeader.changeColor(color: UIColor(red: 255/255, green: 189/255, blue: 80/255, alpha: 1))
        toDoHeader.sectionTitleLabel.text = "Unapproved"//sections[section].items[0].socialTextString
        return toDoHeader.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let todoFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! TableFooterView
        todoFooter.xButton.setImage(UIImage(named: "iconCloseCard")?.withRenderingMode(.alwaysOriginal), for: .normal)
        todoFooter.informationBtn.setImage(UIImage(named: "iconInfoPage")?.withRenderingMode(.alwaysOriginal), for: .normal)
        todoFooter.loadMoreBtn.setImage(UIImage(named: "iconLoadMore")?.withRenderingMode(.alwaysOriginal), for: .normal)
       
        
        return todoFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 109
        } else {
            return 93
        }
    }
    
}
