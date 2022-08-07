//
//  UserProfileManager.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/29.
//

import Foundation
import UIKit

/// ***
/// プロフィール定義
// 型定義だけなので構造体とする
struct Profile: Codable {
    var userName: String = ""            /// ユーザ名(プレイヤー名)
    var birthday: Date                   /// 生年月日
    var sex = Sex.unselected             /// 性別
    var area = Areas.unselected          /// 地域
    var belong: String = ""              /// 所属
    var introMessage: String = ""        /// 自己紹介
    var visibleBirthday: Bool = false    /// 生年月日を公開


    init () {
        birthday = Calendar(identifier: .gregorian)
            .date(from: DateComponents(year: 2000, month: 1, day: 1))!
    }
    
    /// プロフィールを標準出力する
    func printProfile() {
        print("userName        : \(userName)")
        print("birthday        : \(birthday)")
        print("sex             : \(sex)")
        print("area            : \(area)")
        print("belong          : \(belong)")
        print("introMessage    : \(introMessage)")
        print("visibleBirthday : \(visibleBirthday)")
    }
    
}

/// ***
/// 特定ユーザのプロフィール
/// 
class UserProfile: ObservableObject {

    private(set) var userId: String = ""
    @Published private(set) var profile = Profile()
    @Published private(set) var image = UIImage()       /// 画像
                        //TODO: 初期画像を人型のシルエットにしたい

    // Storeを本クラスに持たせるか持たせないかは悩みどころ。
    // 一旦、本クラスに持たせてみる
    private let profStore = ProfileStore()
    // 一旦、本クラスに持たせてみる
    private let profStorage = ProfileStrage()

    /// プロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    /// - Returns: 成功／失敗
    func saveProfile(uId: String, prof: Profile, img: UIImage) -> Int {
        var ret: Int = -1

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }
        userId = uId
        profile = prof
        image = img

        Task {
            let res = await profStore.storeProfile(uId: userId, prof: profile)
            guard res == 0 else {
                print("Error : storeProfile()")
                return
            }
        }
        Task {
            let res = await profStorage.saveProfileImage(uId: userId, image: image)
            guard res == 0 else {
                print("Error : saveProfileImage()")
                return
            }
        }

        ret = 0
        return ret
    }
    
    /// プロフィールを読み込む
    // Viewの描画に関わるインスタンスを更新する場合、必ずメインスレッドで実行する必要がある。
    // 特に指定しない場合、Task{}はメインスレッドで実行されるとは限らない。
    // MainActorを記載することでメインスレッドで実行させることができる。
    @MainActor
    func loadProfile(uId: String) -> Int {
        var ret: Int = -1

        guard !(uId.isEmpty) else {
            print("Error(\(#file):\(#line)) : uId is empty")
            return ret
        }
        userId = uId

        Task {
            let res = await profStore.loadProfile(uId: userId)
            guard res != nil else {
                print("Error : loadProfile()")
                return
            }
            profile = res!  // この行をメインスレッドで実行する必要がある
        }
        Task {
            let res = await profStorage.loadProfileImage(uId: userId)
            guard res != nil else {
                print("Error : loadProfileImage()")
                return
            }
            image = res!  // この行をメインスレッドで実行する必要がある
        }

        ret = 0
        return ret
    }

} // UserProfile

/// ***
/// アプリ使用者本人のプロフィール ※シングルトンにする
final class OwnerProfile: UserProfile {
    override private init() {}
    static let sOwnerProfile = OwnerProfile()
}
