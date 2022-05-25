//
//  CommonUtil.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/06.
//

import Foundation
// swiftUIをimportしない！！ 場合によっては必要かも。。。
// Firebaseをimportしない！！

enum DateStrType {
    case yyyyMMdd
    case MMdd
    case yyyyMd
    case Md
}

/// アプリ全体で使える便利機能をまとめたクラス
final class CommonUtil {
    // いずれもインスタンス生成不要で使える(class funcとする)こと！

    /// 指定された日付を指定されたフォーマットの文字列で返す
    /// - Parameter date: 日付
    /// - Parameter type: フォーマット
    /// - Returns: フォーマットされた日付の文字列
    class func birthStr(date: Date, type: DateStrType) -> String {
        var retStr = ""
        let formatter = DateFormatter()

        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        switch type {
        case .yyyyMMdd:
            formatter.dateFormat = "yyyy'/'MM'/'dd"     // 2000/01/01
        case .MMdd:
            formatter.dateFormat = "MM'/'dd"            // 01/01
        case .yyyyMd:
            formatter.dateFormat = "yyyy'年'M'月'd'日'" // 2000年1月1日
        case .Md:
            formatter.dateFormat = "M'月'd'日'"         // 1月1日
        }

        retStr = formatter.string(from: date)
        return retStr
    }

}
