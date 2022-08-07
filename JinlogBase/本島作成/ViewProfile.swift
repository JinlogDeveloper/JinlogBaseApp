//
//  ViewProfile.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/30.
//

import SwiftUI
// Firebaseをimportしない！！

struct ProfileView: View {
    @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile

    @State private var bufProfile = Profile()
    @State private var bufUserId: String = ""
    let minDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!

    var body: some View {
        
        VStack {
            
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
            
            HStack {
                Text("プレイヤーネーム")
                    .frame(width: 150)
                TextField(
                    "入力してください",
                    text: $bufProfile.userName
                )
                .keyboardType(.namePhonePad)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
            }
            
            HStack {
                Text("生年月日")
                    .frame(width: 150)
                DatePicker(
                    "",
                    selection: $bufProfile.birthday,
                    in: minDate...Date(),
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .frame(width: 150)
            }
            
            HStack {
                Text("性別")
                    .frame(width: 150)
                Picker("", selection: $bufProfile.sex) {
                    ForEach(Sex.allCases, id: \.self) { selectedSex in
                        Text(selectedSex.name).tag(selectedSex)
                    }
                }
                .labelsHidden()
                .frame(width: 150)
            }
            
            HStack {
                Text("地域")
                    .frame(width: 150)
                Picker("", selection: $bufProfile.area) {
                    ForEach(Areas.allCases, id: \.self) { selectedArea in
                        Text(selectedArea.name).tag(selectedArea)
                    }
                }
                .labelsHidden()
                .frame(width: 150)
            }
            
            HStack {
                Text("所属")
                    .frame(width: 150)
                TextField(
                    "入力してください",
                    text: $bufProfile.belong
                )
                .keyboardType(.namePhonePad)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
            }
            
            HStack {
                Text("自己紹介")
                    .frame(width: 150)
                Text("")
                    .frame(width: 150)
            }
            TextField(
                "入力してください",
                text: $bufProfile.introMessage
            )
            .keyboardType(.namePhonePad)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(
                action:{
                    ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                    //TODO: エラー処理
                }
            ) {
                Text("登録")
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

        } // VStack
        .frame(width: 300)
        
    } // body
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
