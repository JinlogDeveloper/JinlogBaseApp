//
//  ProfileView2.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/05/30.
//

import SwiftUI

class SheetShow: ObservableObject {
    @Published var isFirstView:Binding<Bool> = Binding<Bool>.constant(false)
}

//ユーザー情報や設定情報もアプリ内全体で共有
//ListViewの画面とTabViewの5つ目のタブで使用
class SettingData: ObservableObject {
    @Published var option1:String = "abc"
    @Published var option2:Int = 3
    @Published var option3:Int = 5
    @Published var option4:Bool = false
    @Published var option5:Bool = false
}

struct ProfileView2: View {
    //ObservableObjectで宣言した変数のインスタンス作成
    @EnvironmentObject var VShow: SheetShow
    @EnvironmentObject var setting: SettingData
    
    @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
    //OwnerProfile.sOwnerProfile　どういう意味かわかっていない？(yatake)
    
    @State var str = "aaa"
    
    
    var body: some View {

        
        VStack {
            Text("プロフィール画面")
            Text("ユーザーID: " + ownProfile.userId)
                .onAppear(perform: {
                    setting.option1 = ownProfile.profile.userName
                    
                })
    
            
            //Listはここから
            List{
                //Sectionでジャンル別に項目を分類する
                //SectionはListのカッコ内で結合できる
                Section(header:Text("プロフィール編集")) {
                    
                    //NavigationLinkはList内の各項目に追加する
                    NavigationLink(destination: ListView1()) {
                        Text("ユーザーネーム")
                    }.badge(setting.option1)
                    
                    NavigationLink(destination: ListView2()) {
                        Text("数字")
                    }.badge(setting.option2)
                    
                }
                
                
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
    
    struct ListView1: View {
        
        //ObservableObjectで宣言した変数のインスタンス作成
        @EnvironmentObject var setting: SettingData
        
        var body: some View {
            VStack(spacing: 20.0){
                Text("ユーザーネーム")
                    .font(.title)
                
                //入力した文字はObservableObjectで宣言した変数へ直接代入する
                TextField("name",text: $setting.option1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .padding()
                
                Text("ここで入力した文字はリストに表示")
                    .multilineTextAlignment(.center)
                    .frame(width:300)
            }
        }
    }
    
    struct ListView2: View {
        
        //ObservableObjectで宣言した変数のインスタンス作成
        @EnvironmentObject var setting: SettingData
        
        var body: some View {
            
            VStack(spacing:50){
                Text("数字を選択")
                    .font(.title)
                
                //Pickerで選択
                //選択した数字はObservableObjectで宣言した変数へ直接代入する
                Picker(selection: $setting.option2, label: Text("数字を選択")) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                    Text("6").tag(6)
                    Text("7").tag(7)
                    Text("8").tag(8)
                    Text("9").tag(9)
                }
                //Pickerのデザインはホイールにしたかったのでスタイルを指定
                .pickerStyle(WheelPickerStyle())
                
                Text("Pickerでホイール選択\nここで選択した数字はリストに表示")
                    .multilineTextAlignment(.center)
                    .frame(width:300)
            }
        }
    }
    
}

struct ProfileView2_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView2()
    }
}
