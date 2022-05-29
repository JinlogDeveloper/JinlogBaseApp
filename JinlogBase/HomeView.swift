//
//  HomeView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/28.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                //設定ボタン
                Button(action:{
                    
                }){
                    
                    Image(systemName: "gearshape.fill")
                    
                }
            }
            Spacer()
            HStack{
                Spacer()
                Text("ホーム画面")
                    .padding(.all, 20.0) //全ての辺に20余白
                Spacer()
            }
            Spacer()
        }
        
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
