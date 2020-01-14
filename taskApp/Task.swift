//
//  Task.swift
//  taskApp
//
//  Created by 木村旭 on 2020/01/07.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import RealmSwift

class Task : Object {
    //管理用　ID、プライマリーキー
    @objc dynamic var id = 0
    //タイトル
    @objc dynamic var title = ""
    //内容
    @objc dynamic var contents = ""
    //日時
    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
    
    //id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
    //プライマリーキーとはデータベースでそれぞれのデータを一意に識別するためのIDだと思って下さい。ここで変数の前に@objc dynamicというものが付いていることに気がつくと思います。@objc dynamic修飾子は今回使用するデータベースのライブラリであるRealmがKVO(Key Value Observing)という仕組みを利用しているため必要になります。今回は、KVOとはプロパティの変更を監視するための仕組みだということを理解していれば十分です。詳しく学ぶにはAppleのドキュメントが参考になります。
    
    //参考　https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html
    
