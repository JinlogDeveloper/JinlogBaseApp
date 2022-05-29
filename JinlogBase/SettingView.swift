//
//  SettingView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/30.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack{
            HStack{
                //設定ボタン
                Button(action:{
                    
                }){
                    
                    Text("プロフィール")
                    
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
