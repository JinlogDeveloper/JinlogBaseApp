//
//  HomeView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/28.
//

import SwiftUI

struct HomeView: View {
    
    //ボタンが押されたときにtrueにすることで画面遷移させる
    @State var isShowSheetView: Bool = false
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                //Sheet(Modal表示)を使用したViewへの画面遷移
                .sheet(isPresented: $isShowSheetView){
                        SettingView()
                }
                //設定ボタン
                Button(action:{
                    isShowSheetView = true
                }){
                    
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width:35.0,height:35.0)
                    
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
