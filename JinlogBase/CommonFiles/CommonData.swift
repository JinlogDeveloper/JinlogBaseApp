//
//  CommonFile.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/25.
//

import Foundation
import SwiftUI


//-------------------------------------------------------------------------------------
//アプリ内配色の定数を作成する
struct InAppColor {
    static let accent1 = Color("AccentColor")
    static let accent2 = Color("AccentColor2")
    static let mainColor1 = Color("MainColor1")
    static let mainColor2 = Color("MainColor2")
    static let pointColor = Color("PointColor")

    static let backColor = Color("BaseColor")
    static let buttonColor = Color("ButtonColor")
    static let buttonColor2 = Color("ButtonColor2")
    static let strColor = Color("StringColor")
    static let strColorRvs = Color("StringColorReverse")
    static let textFieldColor = Color("MainColor1")
}


//-------------------------------------------------------------------------------------
//特定の画面へ一気に戻りたい場合に使用
//NavigationLinkで遷移する際にこのフラグに紐付ける
final class ReturnViewFrags{

    //ログイン画面に戻るときのフラグ
    static var returnToLoginView: Binding<Bool> = Binding<Bool>.constant(false)
    //トップ画面に戻るときのフラグ
    static var returnToTopView: Binding<Bool> = Binding<Bool>.constant(false)
}
