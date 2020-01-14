//
//  ViewController.swift
//  taskApp
//
//  Created by 木村旭 on 2020/01/06.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    //realmインスタンスを取得
    let realm = try! Realm()
    
    //DB内のタスクが格納されるリスト。
    //以降内容をアップデートするとリスト内は自動的に更新される。
    //DB全データ取得
    var taskArray = try! Realm().objects(Task.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        categoryButton.backgroundColor = .white
        categoryButton.layer.cornerRadius = 5.0
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
      //  print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CellSegue", sender: nil)
    }
    
    //セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    //deleteボタンが押されるときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //データベースから削除する
        try! realm.write {
            self.realm.delete(self.taskArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let IVC = segue.destination as! InputViewController
        
        if segue.identifier == "CellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            IVC.task = taskArray[indexPath!.row]
        } else {
            //Task Classのオブジェクト検索する
            let task = Task()
            let allTasks = realm.objects(Task.self)
            print(allTasks.count)
            if allTasks.count != 0 {
                print(task.id)
                print(task.id)
                task.id = allTasks.max(ofProperty: "id")! + 1
                print(task.id)
            }
            
            IVC.task = task
            
        }
    }
    
    //入力画面から戻ってきたときに、tableviewを更新させる
  //  override func viewWillAppear(_ animated: Bool) {
    //    super .viewWillAppear(animated)
        
      //  tableView.reloadData()
   // }
    
    
    @IBAction func categoryButton(_ sender: Any) {
            

        if categoryTextField.text == "" {
            taskArray = try! Realm().objects(Task.self)
        } else {
            taskArray = realm.objects(Task.self).filter("category == '\(categoryTextField.text!)'")
        }
        tableView.reloadData()
    }
   // error reason: 'Primary key can't be changed after an object is inserted.'
}
