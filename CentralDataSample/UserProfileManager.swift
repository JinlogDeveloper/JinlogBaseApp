//
//  UserProfileManager.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/29.
//

import Foundation
// swiftUIをimportしない！！ 場合によっては必要かも。。。
// Firebaseをimportしない！！

/// ***
/// プロフィール定義
struct Profile {
    var userName: String = ""            /// ユーザ名(プレイヤー名)
    var birthday: Date                   /// 生年月日
    var sex = Sex.unselected             /// 性別
    var area = Areas.unselected          /// 地域
    var belong: String = ""              /// 所属
    var introMessage: String = ""        /// 自己紹介
    var visibleBirthday: Bool = false    /// 生年月日を公開

    init () {
        // = Date() で問題ないが、何か明確な値を入れておくことで
        // デバッグ時に初期値であることを容易に判別できるかなと
        birthday = Calendar(identifier: .gregorian)
            .date(from: DateComponents(year: 2000, month: 1, day: 1))!
    }
}

/// ***
/// 特定ユーザのプロフィール
class UserProfile: ObservableObject {

    private(set) var userId: String = ""
    @Published private(set) var profile = Profile()

    // Storeを本クラスに持たせるか持たせないかは悩みどころ。
    // 一旦、本クラスに持たせてみる
    private let profStore = ProfileStore()

    /// プロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    /// - Returns: 成功／失敗
    func saveProfile(uId: String, prof: Profile) -> Int {
        var ret: Int = -1
        var res: Int = 0

        res = UserProfile.isValid(uId: uId, prof: prof)
        guard res == 0 else {
            print("Error(\(#file):\(#line)) : isValid()")
            return ret
        }
        userId = uId
        profile = prof

        res = profStore.storeProfile(uId: userId, prof: profile)
        guard res == 0 else {
            print("Error(\(#file):\(#line)) : storeProfile()")
            return ret
        }

        ret = 0
        return ret
    }
    
    /// プロフィールを読み込む
    func loadProfile(uId: String) -> Int {
        var ret: Int = -1
        var res: Int = 0

        guard !(uId.isEmpty) else {
            print("Error(\(#file):\(#line)) : uId is empty")
            return ret
        }
        userId = uId

        res = profStore.loadProfile(prof: self)
        guard res == 0 else {
            print("Error(\(#file):\(#line)) : loadProfile()")
            return ret
        }

        ret = 0
        return ret
    }

    //TODO: 
    func setPrifile(prof: Profile) {
        profile = prof
    }

    /// ユーザIDとプロフィールが有効かチェックする
    /// - Parameters:
    ///   - uId: ユーザID
    ///   - prof: プロフィール
    /// - Returns: 成功／失敗
    class func isValid(uId: String, prof: Profile) -> Int {
        var ret: Int = -1

        guard !(uId.isEmpty) else {
            print("Error(\(#file):\(#line)) : uId is empty")
            return ret
        }
        guard !(prof.userName.isEmpty) else {
            print("Error(\(#file):\(#line)) : userName is empty")
            return ret
        }
        // 他にもチェックする必要があれば、ここに追加していく。

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
