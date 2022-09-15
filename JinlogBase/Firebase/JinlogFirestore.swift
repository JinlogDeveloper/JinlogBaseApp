//
//  JinlogFirestore.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/03.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum rootCollections: String {
    case profiles = "profiles"
    case settings = "settings"
}

/// プロフィール用のDBに直接アクセスする処理を集めたクラス
final actor ProfileStore {

    private let db: CollectionReference

    init() {
        db = Firestore.firestore().collection(rootCollections.profiles.rawValue)
    }

    /// データベースにプロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    func storeProfile(uId: String, prof: Profile) async throws {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }

        // 辞書型に変換
        var dictionary: [String : Any]
        do {
            dictionary = try Firestore.Encoder().encode(prof)
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }

        // ドキュメント保存
        do {
            try await db.document(uId).setData(dictionary)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }

    /// データベースからプロフィールを読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID
    /// - Returns: Profile
    func loadProfile(uId: String) async throws -> Profile {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }

        // ドキュメント取得
        var document: DocumentSnapshot
        do {
            document = try await db.document(uId).getDocument(source: .server)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }

        // ドキュメントなし
        guard document.exists == true else {
            print("Error : document not found")
            throw JinlogError.noProfileInDB
        }

        // ドキュメント変換
        do {
            let profile = try document.data(as: Profile.self)
            return profile
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
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
