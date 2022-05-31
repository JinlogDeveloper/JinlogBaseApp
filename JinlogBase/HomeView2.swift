//
//  TestNavi.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/31.
//

import SwiftUI

struct HomeView2: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("ホーム画面2")
            } //VStack　ここまで
            
            .navigationBarItems(trailing: NavigationLink(destination: SettingView()) {
                
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width:35.0,height:35.0)
            } //NavigationLink　ここまで
            ) //.navigationBarItems　ここまで
        } // NavigatonView　ここまで
    } // body ここまで
} //HomeView2　ここまで

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}
