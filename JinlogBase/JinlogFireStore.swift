//
//  JinlogFireStore.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/03.
//

import Foundation
import Firebase
// swiftUIをimportしない！！

// 現状、ほぼメモとしての役割
enum rootCollections: String {
    case profiles = "profiles"  // 最低限のベースは作った
    case settings = "settings"  // 構想までした
    case friends = "friends"    // 構想までした
    case games = "games"        // 超テキトー。イメージを膨らませる用
    case logs = "logs"          // 超テキトー。イメージを膨らませる用
    case events = "events"      // 超テキトー。イメージを膨らませる用
}

/// プロフィール用のDBに直接アクセスする処理を集めたクラス
// 今後どれほど膨れ上がるか分からないため、
// 規模が大きくなってきたら分け方を考える
final class ProfileStore {
    
    private let db: Firestore
    
    init() {
        // Firebase未初期化の時だけ初期化実行
        // 初回のみ警告ログが出力される。
        // ※未configure() なのに app() を覗いてるため
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        db = Firestore.firestore()
    }
    
    /// データベースにプロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    /// - Returns: 成功／失敗
    func storeProfile(uId: String, prof: Profile) -> Int {
        var ret: Int = -1
        
        guard !(uId.isEmpty) else {
            print("Error(\(#file):\(#line)) : uId is empty")
            return ret
        }
        
        // プログラム上の事故防止を目的に、
        // 本人のみ書き込み可能とする処理を入れる？
        // ※もちろんFirestoreのセキュリティルールは書いた上で
        //guard userId == Authでサインイン中のuId else {
        //    print("The userID does not match the owner's userID")
        //    return ret
        //}
        
        print("setData()")
        //TODO: きれいに書き直す
        db.collection(rootCollections.profiles.rawValue)
            .document(uId)
            .setData([
                "userName":     prof.userName,
                "birthday":     Timestamp(date: prof.birthday),
                "sex":          prof.sex.rawValue,
                "area":         prof.area.rawValue,
                "belong":       prof.belong,
                "introMessage": prof.introMessage,
            ])
        //TODO: エラー処理追加
        
        ret = 0
        return ret
    }
    
    /// データベースからプロフィールを読み込む
    /// - Parameters:
    ///   - uId: 読み込むプロフィールのユーザID
    ///   - prof: 読み込み先プロフィール
    /// - Returns: 成功／失敗
    func loadProfile(prof: UserProfile) -> Int {
        var ret: Int = -1
        var bufProfile = Profile()
        var bufInt: Int = 0
        
        guard !(prof.userId.isEmpty) else {
            print("Error(\(#file):\(#line)) : userId is empty")
            return ret
        }
        
        db.collection(rootCollections.profiles.rawValue)
            .document(prof.userId)
            .getDocument() { (result, error) in
                if let err = error {
                    print("Error(\(#file):\(#line)) : getDocument()")
                    return
                }
                guard let res = result?.data() else {
                    print("Error(\(#file):\(#line)) : getDocument()")
                    return
                }
                print("getDocument() : \(res)")
                
                // データ取り出し
                //TODO: きれいに書き直す
                bufProfile.userName = res["userName"] as? String ?? ""
                bufProfile.birthday = (res["birthday"] as? Timestamp ?? Timestamp()).dateValue()

                bufInt = res["sex"] as? Int ?? 0
                bufProfile.sex = Sex.intToSex(num: bufInt)

                bufInt = res["area"] as? Int ?? 0
                bufProfile.area = Areas.intToAreas(num: bufInt)

                bufProfile.belong = res["belong"] as? String ?? ""
                bufProfile.introMessage = res["introMessage"] as? String ?? ""

                print("\(bufProfile.userName)")
                print("\(bufProfile.birthday)")
                print("\(bufProfile.sex)")
                print("\(bufProfile.area)")
                print("\(bufProfile.belong)")
                print("\(bufProfile.introMessage)")

                //TODO: 正しい方法で書き直す。このコールバックのやり方はNG。
                prof.setPrifile(prof: bufProfile)
            }

        ret = 0
        return ret
    }
}
