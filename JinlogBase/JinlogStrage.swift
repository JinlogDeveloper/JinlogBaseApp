//
//  JinlogStorage.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/07/06.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

// Storageルート配下のフォルダ名
enum rootReference: String {
    case profiles = "profiles"
}

/// プロフィール用のStorageに直接アクセスする処理を集めたクラス
final class ProfileStrage {
    
    private let sMaxDataSize: Int64 = 10 * 1024 * 1024
    private let storage: StorageReference

    init() {
        // Firebase未初期化の時だけ初期化実行
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        storage = Storage.storage().reference(withPath: rootReference.profiles.rawValue)
    }

    /// ストレージにプロフィール画像を保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィール画像のユーザID
    ///   - image: 保存するプロフィール画像
    /// - Returns: 成功0／失敗-1
    func saveProfileImage(uId: String, image: UIImage) async -> Int {
        var ret: Int = -1
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }
        guard let pngData = image.pngData() else {
            print("Error : could not convert to PNG")
            return ret
        }
        let ref: StorageReference = storage.child("\(uId).png")

        do {
            try await ref.putDataAsync(pngData, metadata: metaData)
        } catch {
            print("Error : ", error.localizedDescription)
            //TODO:
            return ret
        }
        
        ret = 0
        return ret
    }

    /// ストレージからプロフィール画像を読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID
    /// - Returns: 成功Profile／失敗nil
    func loadProfileImage(uId: String) async -> UIImage? {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return nil
        }
        let ref: StorageReference = storage.child("\(uId).png")
        
        do {
            let res = try await ref.data(maxSize: sMaxDataSize)
            let retImage = UIImage(data: res)
            print("imageDataSize   : \(res.count)[byte]")
            return retImage
        } catch {
            print("Error : ", error.localizedDescription)
            //TODO:
            return nil
        }
    }

}
