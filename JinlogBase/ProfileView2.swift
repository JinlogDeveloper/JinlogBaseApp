//
//  ProfileView2.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/30.
//

import SwiftUI

struct ProfileView2: View {
    @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
    
    
    var body: some View {
        
        VStack {
            Text("プロフィール画面")
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

struct ProfileView2_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView2()
    }
}
