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
    @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
    
    
    var body: some View {
        
        //NavigationView{
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
            VStack{
                Spacer()
                Text("ホーム画面")
                    .padding(.all, 20.0) //全ての辺に20余白
                
                Image(uiImage: ownProfile.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .background(.white)
                    .padding(20)
                    
                Spacer()
            }
            Spacer()
            
        } //VStack　ここまで
        .onAppear {
            ownProfile.loadProfile(uId: "aaa")
            
        }
        
        
        //  } //NavigationView　ここまで
        
    } //body ここまで
} //HomeView　ここまで

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
