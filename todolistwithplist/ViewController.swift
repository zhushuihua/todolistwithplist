//
//  ViewController.swift
//  todolistwithplist
//
//  Created by Shuihua Zhu on 27/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    @IBOutlet weak var tableView: UITableView!
    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField:UITextField!
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            textField = tf
            tf.placeholder = "add item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let item = Item()
            item.title = textField.text!
            self.items.append(item)
            self.tableView.reloadData()
            self.saveItems()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    func saveItems()
    {
        let coder = PropertyListEncoder()
        if let data = try? coder.encode(items)
        {
            try? data.write(to: filePath!)
        }
    }
    func loadItems()
    {
        let decoder = PropertyListDecoder()
        guard let data = try? Data(contentsOf: filePath!) else{
            return
        }
        guard let items = try? decoder.decode([Item].self, from: data)
            else{
                return
        }
        self.items = items
        tableView.reloadData()
    }
}

