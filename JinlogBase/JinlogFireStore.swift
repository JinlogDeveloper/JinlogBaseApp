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
    
//    private let db: Firestore
    private let db: CollectionReference
    
    init() {
        // Firebase未初期化の時だけ初期化実行
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
//        db = Firestore.firestore()
        db = Firestore.firestore().collection(rootCollections.profiles.rawValue)
    }
    
    /// データベースにプロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    /// - Returns: 成功／失敗
//    func storeProfile(uId: String, prof: Profile) -> Int {
    func storeProfile(uId: String, prof: Profile) async -> Int {
        var ret: Int = -1
        
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }
        let profDictionary = convertProfileToDic(prof: prof)

        // 本人のみ書き込み可能とする処理を入れる？
        // ※もちろんFirestoreのセキュリティルールは書いた上で
        //guard userId == Authでサインイン中のuId else {
        //    print("The userID does not match the owner's userID")
        //    return ret
        //}
        
//        print("setData()")
//        //TODO: きれいに書き直す
//        db.collection(rootCollections.profiles.rawValue)
//            .document(uId)
//            .setData([
//                "userName":     prof.userName,
//                "birthday":     Timestamp(date: prof.birthday),
//                "sex":          prof.sex.rawValue,
//                "area":         prof.area.rawValue,
//                "belong":       prof.belong,
//                "introMessage": prof.introMessage,
//            ])
//
        
        do {
            try await db.document(uId).setData(profDictionary)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            
            switch errorCode {  //TODO: どう処理するか検討(呼び元も含め)
            case .invalidArgument:
                return ret
            case .notFound:
                return ret
            case .permissionDenied:
                return ret
            default:
                return ret
            }
        }
        
        
        ret = 0
        return ret
    }
    
    /// データベースからプロフィールを読み込む
    /// - Parameters:
    ///   - uId: 読み込むプロフィールのユーザID
    ///   - prof: 読み込み先プロフィール
    /// - Returns: 成功／失敗
//    func loadProfile(prof: UserProfile) -> Int {
    func loadProfile(uId: String) async -> Profile? {
//        var ret: Int = -1
//        var bufProfile = Profile()
//        var bufInt: Int = 0
        
//        guard !(prof.userId.isEmpty) else {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return nil
        }
        
        
        do {
            let res = try await db.document(uId).getDocument()
            print("res.exists : \(res.exists)")
            let retProfile = convertDocToProfile(profDoc: res)
            return retProfile
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            
            switch errorCode {  //TODO:  どう処理するか検討(呼び元も含め)
            case .invalidArgument:
                return nil
            case .notFound:
                return nil
            case .permissionDenied:
                return nil
            default:
                return nil
            }
        }
    }
//        db.collection(rootCollections.profiles.rawValue)
//            .document(prof.userId)
//            .getDocument() { (result, error) in
//                if let err = error {
//                    print("Error(\(#file):\(#line)) : getDocument()")
//                    return
//                }
//                guard let res = result?.data() else {
//                    print("Error(\(#file):\(#line)) : getDocument()")
//                    return
//                }
//                print("getDocument() : \(res)")
//
//                // データ取り出し
//                //TODO: きれいに書き直す
//                bufProfile.userName = res["userName"] as? String ?? ""
//                bufProfile.birthday = (res["birthday"] as? Timestamp ?? Timestamp()).dateValue()
//
//                bufInt = res["sex"] as? Int ?? 0
//                bufProfile.sex = Sex.intToSex(num: bufInt)
//
//                bufInt = res["area"] as? Int ?? 0
//                bufProfile.area = Areas.intToAreas(num: bufInt)
//
//                bufProfile.belong = res["belong"] as? String ?? ""
//                bufProfile.introMessage = res["introMessage"] as? String ?? ""
//
//                print("\(bufProfile.userName)")
//                print("\(bufProfile.birthday)")
//                print("\(bufProfile.sex)")
//                print("\(bufProfile.area)")
//                print("\(bufProfile.belong)")
//                print("\(bufProfile.introMessage)")
//
//                //TODO: 正しい方法で書き直す。このコールバックのやり方はNG。
//                prof.setPrifile(prof: bufProfile)
//            }
//
//        ret = 0
//        return ret
//    }
    
    
    /// Profile型を辞書型に変換する
    /// - Parameter prof: 変換元データ
    /// - Returns: 変換後データ
    private func convertProfileToDic(prof: Profile) -> [String: Any] {
        let retDictionary: [String: Any] = [
            "userName":         prof.userName,
            "birthday":         Timestamp(date: prof.birthday),
            "sex":              prof.sex.rawValue,
            "area":             prof.area.rawValue,
            "belong":           prof.belong,
            "introMessage":     prof.introMessage,
            "visibleBirthday":  prof.visibleBirthday,
        ]
        return retDictionary
    }
    
    /// FirestoreのDocumentSnapshotをProfile型に変換する
    /// - Parameter profDoc: 変換元データ
    /// - Returns: 変換後データ
    // 引数が必ずしもプロフィールのDocumentSnapshotとは限らないため危険。
    // 少なくとも全くの外部から呼び出されることはないようにするため、funcをprivateで宣言した
    private func convertDocToProfile(profDoc: DocumentSnapshot) -> Profile {
        var retProfile = Profile()

        if profDoc.exists {
            //TODO: きれいに書き直す
            retProfile.userName         = profDoc["userName"] as? String ?? ""
            retProfile.birthday         = (profDoc["birthday"] as? Timestamp ?? Timestamp()).dateValue()
            retProfile.sex              = Sex.intToSex(num: profDoc["sex"] as? Int ?? 0)
            retProfile.area             = Areas.intToAreas(num: profDoc["area"] as? Int ?? 0)
            retProfile.belong           = profDoc["belong"] as? String ?? ""
            retProfile.introMessage     = profDoc["introMessage"] as? String ?? ""
            retProfile.visibleBirthday  = profDoc["visibleBirthday"] as? Bool ?? false
        }

        retProfile.printProfile()
        return retProfile
    }
    
    
    
    
}
