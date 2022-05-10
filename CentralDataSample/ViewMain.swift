//
//  ViewMain.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/24.
//

import SwiftUI
// Firebaseをimportしない！！

struct MainView: View {
    @State private var isShowingModal: Bool = false

    @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
    @State private var bufUserId: String = ""
    
    let minDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
    
    var body: some View {
        
        VStack {
            
            Button(
                action:{
                    isShowingModal = true
                }
            ) {
                Text("プロフィール編集")
                    .background(.orange)
            }
            .padding()
            .sheet(isPresented: $isShowingModal) {
                let _ = print("なぜか2回走る")
                ProfileView()
            }
            .padding()
            
            HStack {
                Text("userId (実験用)")
                    .frame(width: 150)
                TextField(
                    "※実験用※",
                    text: $bufUserId
                )
                .keyboardType(.asciiCapable)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
            }

            Button(
                action:{
                    ownProfile.loadProfile(uId: bufUserId)
                    //TODO: エラー処理
                }
            ) {
                Text("読み込み")
                    .frame(width: 180, height: 50)
            }
            .font(.system(size: 36))
            .background(.yellow)

            VStack {
                Text("■自動で描画に反映されることの確認■")
                Text(ownProfile.userId)
                Text(ownProfile.profile.userName)
                Text(CommonUtil.birthStr(date: ownProfile.profile.birthday, type: .yyyyMd))
                Text(ownProfile.profile.sex.name)
                Text(ownProfile.profile.area.name)
                Text(ownProfile.profile.belong)
                Text(ownProfile.profile.introMessage)
            }
            .frame(width: 300)
            .background(.green)

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
