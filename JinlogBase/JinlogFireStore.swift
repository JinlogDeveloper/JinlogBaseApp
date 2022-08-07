//
//  JinlogFireStore.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/03.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

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
final actor ProfileStore {

    private let db: CollectionReference

    init() {
        // Firebase未初期化の時だけ初期化実行
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        db = Firestore.firestore().collection(rootCollections.profiles.rawValue)
    }

    /// データベースにプロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    /// - Returns: 成功／失敗
    func storeProfile(uId: String, prof: Profile) async -> Int {
        var ret: Int = -1
        
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }

        // 本人のみ書き込み可能とする処理を入れる？
        // ※もちろんFirestoreのセキュリティルールは書いた上で
        //guard userId == Authでサインイン中のuId else {
        //    print("The userID does not match the owner's userID")
        //    return ret
        //}

        do {
            try db.document(uId).setData(from: prof)
            ret = 0
            return ret
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return ret
        }
    }

    /// データベースからプロフィールを読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID
    /// - Returns: 成功Profile／失敗nil
    func loadProfile(uId: String) async -> Profile? {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return nil
        }

        do {
            let res = try await db.document(uId).getDocument(as: Profile.self)
            return res
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return nil
        }
    }

    /// データベースから複数のプロフィールを読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID配列
    func loadProfiles(uId: [String]) async -> [Profile]? {
        var ret: [Profile]? = nil

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }

        print(uId)
        do {
            let profs = try await db.whereField(FieldPath.documentID(), in: uId).getDocuments()
                .documents.compactMap{ try $0.data(as: Profile.self) }
            ret = profs
            return ret
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return ret
        }
    }

}

/// 設定用のDBに直接アクセスする処理を集めたクラス
final actor SettingStore {

    private let db: CollectionReference

    init() {
        // Firebase未初期化の時だけ初期化実行
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        db = Firestore.firestore().collection(rootCollections.settings.rawValue)
    }

    /// データベースに設定を保存する
    /// - Parameters:
    ///   - uId: 保存する設定のユーザID
    ///   - prof: 保存する設定
    /// - Returns: 成功0／失敗-1
    func storeSetting(uId: String, setting: Setting) async -> Int {
        var ret: Int = -1

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }

        do {
            try db.document(uId).setData(from: setting)
            ret = 0
            return ret
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return ret
        }
    }

    /// データベースから設定を読み込む
    /// - Parameter uId: 読み込む設定のユーザID
    /// - Returns: 成功Profile／失敗nil
    func loadSetting(uId: String) async -> Setting? {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return nil
        }

        do {
            let res = try await db.document(uId).getDocument(as: Setting.self)
            return res
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return nil
        }
    }

}
