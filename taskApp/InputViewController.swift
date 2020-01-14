//
//  InputViewController.swift
//  taskApp
//
//  Created by 木村旭 on 2020/01/07.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    //課題用に追加
    @IBOutlet weak var categoryTextField: UITextField!
    //categoryTextFieldに入力されたデータを配列に保存
   // var categoryArray = [String]()
    var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //キーボードをタッチをすると、dismissKeyboardを呼び出す
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTextField.text = task.category
        
    }
            
    @objc func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }

    
    //メソッドが遷移する際、画面が非表示になると呼ばれるメソッド
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: .modified)
        }
        setNotification(task: task)

        super.viewWillDisappear(animated)
    }

    //タスクのローカル通知を登録する。　-- ここから
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定(中身がない場合、メッセージなしで音だけの通知になるので、『xxなし』を表示する)
        
        if task.title == ""{
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if content.body == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        //ローカル通知を発動するtrigger（日付マッチ）を作成する
        let calendar = Calendar.current
        //カレンダーの要素を一括で取得
        let dateComponent = calendar.dateComponents([.year ,.month, .day, .hour, .minute ], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //identifer, content, triggerからローカル通知を作成(identiferが同じならローカル通知を上書き保存)
        let request = UNNotificationRequest(identifier: String(task.id), content: content , trigger: trigger)
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            //error がnilならローカル通知の登録に成功したと表示します。errorが存在（nilじゃなければ）すれば、errorを表示します。
            print(error ?? "ローカル通知登録OK")
        }
        
        //未通知のローカル通知一覧ログを出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("--------")
                print(request)
                print("--------")
            }
        }
    }
    
}
    



