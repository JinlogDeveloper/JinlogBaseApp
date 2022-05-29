//
//  SettingView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/30.
//

import SwiftUI

struct SettingView: View {
    
    @State var isShowNaviView: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                //設定ボタン
                Button(action:{
                    isShowNaviView = true
                }){
                    NavigationLink(destination: ProfileView2(), isActive: $isShowNaviView){
                    Text("プロフィール")
                        .padding(.top, 50.0)
                    }
                    
                }
            }
            Spacer()
            HStack{
                Spacer()
                Text("設定画面")
                    .padding(.all, 20.0) //全ての辺に20余白
                Spacer()
            }
            Spacer()

        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
