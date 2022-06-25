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

struct ProfileView2: View {
    //ObservableObjectで宣言した変数のインスタンス作成
    @EnvironmentObject var VShow: SheetShow
    @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile

    
    @State private var bufProfile = Profile()
    @State private var bufUserId: String = ""
  
    
    var body: some View {

        
        VStack {
            Text("プロフィール画面")
            Text("ユーザーID: " + ownProfile.userId)
            
            //Listはここから
            List{
                //Sectionでジャンル別に項目を分類する
                //SectionはListのカッコ内で結合できる
                Section(header:Text("プロフィール編集")) {
                    
                    //NavigationLinkはList内の各項目に追加する
                    NavigationLink(destination: ListNameView()) {
                        Text("ユーザーネーム")
                }.badge(ownProfile.profile.userName)
                    
                    NavigationLink(destination: ListBirthdayView()) {
                        Text("誕生日")
                    }.badge(CommonUtil.birthStr(date: ownProfile.profile.birthday, type: .yyyyMd))
                    
                    NavigationLink(destination: ListSexView()) {
                        Text("性別")
                    }.badge(ownProfile.profile.sex.name)
                    
                    
                    NavigationLink(destination: ListAreaView()) {
                        Text("都道府県")
                    }.badge(ownProfile.profile.area.name)
                    
                    NavigationLink(destination: ListbelongView()) {
                        Text("所属")
                    }.badge(ownProfile.profile.belong)
                    
                    
                    
                    NavigationLink(destination: ListIntroMessageView()) {
                        Text("自己紹介")
                    }.badge(ownProfile.profile.introMessage)
                    
                    
                    
                    
                }
                
                
                Text("ユーザー名：" + ownProfile.profile.userName)
                Text("誕生日：" + CommonUtil.birthStr(date: ownProfile.profile.birthday, type: .yyyyMd))
                Text("性別：" + ownProfile.profile.sex.name)
                Text("都道府県：" + ownProfile.profile.area.name)
                Text("所属：" + ownProfile.profile.belong)
                Text("自己紹介：" + ownProfile.profile.introMessage)
            }
            .frame(width: 300)
            .background(.green)
            
        }
        
    }
    
    struct ListNameView: View {
        @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = OwnerProfile.sOwnerProfile.userId

        @Environment(\.presentationMode) var presentation
        
           
        
        var body: some View {
            VStack(spacing: 20.0){
                Text("ユーザーネーム")
                    .font(.title)
                
                //入力した文字はObservableObjectで宣言した変数へ直接代入する
                TextField("ユーザーネーム",text: $bufProfile.userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .padding()
                
                Text("ここで入力した文字はリストに表示")
                    .multilineTextAlignment(.center)
                    .frame(width:300)
                
                
                Button(
                    action:{
                       ownProfile.saveProfile(uId: bufUserId, prof: bufProfile)
                        self.presentation.wrappedValue.dismiss()
                    }
                ) {
                    Text("登録")
                        .frame(width: 180, height: 50)
                }
                .font(.system(size: 36))
                .background(.yellow)
                
                
                
                
            }
            .onAppear {
                bufProfile =  ownProfile.profile
                
            }
        
        }
    }
    
    struct ListSexView: View {
        @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = OwnerProfile.sOwnerProfile.userId
        
        @Environment(\.presentationMode) var presentation
        
        var body: some View {
            
            VStack(spacing:50){
                Text("性別を選択")
                    .font(.title)
                
                //Pickerで選択
                //選択した数字はObservableObjectで宣言した変数へ直接代入する
                Picker(selection: $bufProfile.sex, label: Text("性別を選択")) {
                    ForEach(Sex.allCases, id: \.self) { selectedSex in
                        Text(selectedSex.name).tag(selectedSex)
                    }
                }
                }
                //Pickerのデザインはホイールにしたかったのでスタイルを指定
                .pickerStyle(WheelPickerStyle())
                .onAppear {
                    bufProfile =  ownProfile.profile
                }

                
                Button(
                    action:{
      
                       ownProfile.saveProfile(uId: bufUserId, prof: bufProfile)
                        self.presentation.wrappedValue.dismiss()
                        
                    }
                ) {
                    Text("登録")
                        .frame(width: 180, height: 50)
                }
                .font(.system(size: 36))
                .background(.yellow)
                
            }
        }
    
    struct ListAreaView: View {
        private var ownProfile = OwnerProfile.sOwnerProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = OwnerProfile.sOwnerProfile.userId
        
        @Environment(\.presentationMode) var presentation
        
        var body: some View {
            
            VStack(spacing:50){
                Text("都道府県を選択")
                    .font(.title)
                
                //Pickerで選択
                //選択した数字はObservableObjectで宣言した変数へ直接代入する
                Picker(selection: $bufProfile.area, label: Text("都道府県を選択")) {
                    ForEach(Areas.allCases, id: \.self) { selectedAreas in
                        Text(selectedAreas.name).tag(selectedAreas)
                    }
                }
                }
                //Pickerのデザインはホイールにしたかったのでスタイルを指定
                .pickerStyle(WheelPickerStyle())
                .onAppear {
                    bufProfile =  ownProfile.profile
                }

                
                Button(
                    action:{
      
                       ownProfile.saveProfile(uId: bufUserId, prof: bufProfile)
                        self.presentation.wrappedValue.dismiss()
                        
                    }
                ) {
                    Text("登録")
                        .frame(width: 180, height: 50)
                }
                .font(.system(size: 36))
                .background(.yellow)
                
            }
        }
    
    
    struct ListbelongView: View {
        @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = OwnerProfile.sOwnerProfile.userId

        @Environment(\.presentationMode) var presentation
        
           
        
        var body: some View {
            VStack(spacing: 20.0){
                Text("所属")
                    .font(.title)
                
                //入力した文字はObservableObjectで宣言した変数へ直接代入する
                TextField("所属",text: $bufProfile.belong)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .padding()
                
                Text("ここで入力した文字はリストに表示")
                    .multilineTextAlignment(.center)
                    .frame(width:300)
                
                
                Button(
                    action:{
                       ownProfile.saveProfile(uId: bufUserId, prof: bufProfile)
                        self.presentation.wrappedValue.dismiss()
                    }
                ) {
                    Text("登録")
                        .frame(width: 180, height: 50)
                }
                .font(.system(size: 36))
                .background(.yellow)
                
                
                
                
            }
            .onAppear {
                bufProfile =  ownProfile.profile
                
            }
        
        }
    }
    
    struct ListIntroMessageView: View {
        @ObservedObject private var ownProfile = OwnerProfile.sOwnerProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = OwnerProfile.sOwnerProfile.userId

        @Environment(\.presentationMode) var presentation
        
           
        
        var body: some View {
            VStack(spacing: 20.0){
                Text("自己紹介")
                    .font(.title)
                
                //入力した文字はObservableObjectで宣言した変数へ直接代入する
                TextField("自己紹介",text: $bufProfile.introMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .padding()
                
                Text("ここで入力した文字はリストに表示")
                    .multilineTextAlignment(.center)
                    .frame(width:300)
                
                
                Button(
                    action:{
                       ownProfile.saveProfile(uId: bufUserId, prof: bufProfile)
                        self.presentation.wrappedValue.dismiss()
                    }
                ) {
                    Text("登録")
                        .frame(width: 180, height: 50)
                }
                .font(.system(size: 36))
                .background(.yellow)
                
                
                
                
            }
            .onAppear {
                bufProfile =  ownProfile.profile
                
            }
        
        }
    }
    
    struct ListBirthdayView: View {
        private var ownProfile = OwnerProfile.sOwnerProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = OwnerProfile.sOwnerProfile.userId
        
        @Environment(\.presentationMode) var presentation
        
        var body: some View {
            
            VStack(spacing:50){
                Text("誕生日を選択")
                    .font(.title)
                
                //Pickerで選択
                //選択した数字はObservableObjectで宣言した変数へ直接代入する
                DatePicker("誕生日を選択",selection: $bufProfile.birthday, displayedComponents: .date)
                //Pickerのデザインはホイールにしたかったのでスタイルを指定
                    .datePickerStyle(WheelDatePickerStyle())
                //.pickerStyle(WheelPickerStyle())
                .onAppear {
                    bufProfile =  ownProfile.profile
                }

                
                Button(
                    action:{
      
                       ownProfile.saveProfile(uId: bufUserId, prof: bufProfile)
                        self.presentation.wrappedValue.dismiss()
                        
                    }
                ) {
                    Text("登録")
                        .frame(width: 180, height: 50)
                }
                .font(.system(size: 36))
                .background(.yellow)
                
            }
        }
    
    
    }
}

struct ProfileView2_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView2()
    }
}
