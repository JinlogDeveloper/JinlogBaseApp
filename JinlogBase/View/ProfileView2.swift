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
    @ObservedObject private var ownProfile = Owner.sProfile
    @State private var bufProfile = Profile()
    @State private var bufUserId: String = ""
    
    @State var showImage:UIImage? = nil
    @State var editMode: Bool = false
    
    
    var body: some View {
        
        
        VStack {
            
            ZStack {
                Color(UIColor(InAppColor.mainColor2))
                    .ignoresSafeArea()
                    .shadow(radius: 7)
                    .frame(height: 210)
                //Text("プロフィール画面")
                UserImageView(showImage: showImage)
            }
            
            if editMode {
                //Listはここから
                List {
                    //Sectionでジャンル別に項目を分類する
                    //SectionはListのカッコ内で結合できる
                    Section(header:Text("ユーザーネーム")) {
                        //NavigationLinkはList内の各項目に追加する
                        NavigationLink(destination: ListNameView()) {
                            Text(ownProfile.profile.userName)
                        }//.badge(ownProfile.profile.userName)
                    }
                    
                    Section(header:Text("メールアドレス")) {
                        NavigationLink(destination: ListBirthdayView()) {
                            Text("sample.com")
                        }//.badge(CommonUtil.birthStr(date: ownProfile.profile.birthday, type: .yyyyMd))
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    
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
            }
            else {
                List {
                    //Sectionでジャンル別に項目を分類する
                    //SectionはListのカッコ内で結合できる
                    Section(header:Text("ユーザーネーム")) {
                        //NavigationLinkはList内の各項目に追加する
                        Text(ownProfile.profile.userName)
                    }
                    
                    Section(header:Text("メールアドレス")) {
                        Text("sample.com")
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    
                    Text("誕生日")
                        .badge(CommonUtil.birthStr(date: ownProfile.profile.birthday, type: .yyyyMd))
                    Text("性別")
                        .badge(ownProfile.profile.sex.name)
                    Text("都道府県")
                        .badge(ownProfile.profile.area.name)
                    Text("所属")
                        .badge(ownProfile.profile.belong)
                    Text("自己紹介")
                        .badge(ownProfile.profile.introMessage)
                }
            }
        }
        .onAppear(){
            showImage = ownProfile.image
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("プロフィール")
        .toolbar {
            // ナビゲーションバー左に編集アイコン追加
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editMode.toggle()
                } label: {
                    if editMode {
                        Text("編集終了")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(InAppColor.accent1)
                            .clipShape(Capsule())
                    }
                    else {
                        Text("編集")
                            .font(.system(size: 19))
                    }
                }

            }
        }
    }
    
    struct UserImageView: View {
        
        @State var showImage:UIImage? = nil
        // 撮影画面のsheet
        @State var isShowSheet = false
        @State var isPhotolibrary = false
        @State var isShowAction = false
        // 撮影する写真を保持する状態変数
        @State var captureImage: UIImage? = nil
        
        var body: some View {
            
            VStack {
                // 「画像を選択」ボタン
                Button(action: {
                    // ボタンをタップしたときのアクション
                    // 撮影写真を初期化する
                    captureImage = nil
                    // ActionSheetを表示する
                    isShowAction = true
                }) {
                    
                    ZStack {
                        if showImage != nil {
                            if let unwrapShowImage = showImage {
                                // 表示する写真がある場合は画面に表示
                                Image(uiImage: unwrapShowImage)
                                //Image("bbb")
                                
                                // リサイズする
                                    .resizable()
                                // アスペクト比（縦横比）を維持して画面内に
                                // 収まるようにする
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                            }
                        } else
                        {
                            Image("bbb")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110)
                                .clipShape(Circle())
                        }
                        
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                            .foregroundStyle(InAppColor.mainColor1, InAppColor.buttonColor)
                            .offset(x: 45, y: 45)
                    }
                } // 「画像を選択」ボタンここまで
                // 上下左右に余白を追加
                .padding(5)
                
                // sheetを表示
                // 状態変数:$isShowActionに変化があったら実行
                .actionSheet(isPresented: $isShowAction) {
                    // ActionSheetを表示するin
                    ActionSheet(title: Text("確認"),
                                message: Text("選択してください"),
                                buttons: [
                                    .default(Text("カメラ"), action: {
                                        // カメラを選択
                                        isPhotolibrary = false
                                        // カメラが利用可能かチェック
                                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                                            print("カメラは利用できます")
                                            
                                            // カメラが使えるなら、isShowSheetをtrue
                                            isShowSheet = true
                                        } else {
                                            print("カメラは利用できません")
                                            debugPrint("デバックプリント確認")
                                        }
                                    }),
                                    .default(Text("フォトライブラリー"), action: {
                                        // フォトライブラリーを選択
                                        isPhotolibrary = true
                                        // isShowSheetをtrue
                                        isShowSheet = true
                                    }),
                                    // キャンセル
                                    .cancel(),
                                ]) // ActionSheetここまで
                } // .actionSheetここまで
                // isPresentedで指定した状態変数がtrueのとき実行
                .sheet(isPresented: $isShowSheet) {
                    if let unwrapCaptureImage = captureImage{
                        // 撮影した写真がある→EffectViewを表示する
                        EffectView(
                            isShowSheet: $isShowSheet,
                            captureImage: unwrapCaptureImage,
                            showImage:$showImage)
                    } else {
                        // フォトライブラリーが選択された
                        if  isPhotolibrary {
                            // PHPickerViewController(フォトライブラリー)を表示
                            PHPickerView(
                                isShowSheet: $isShowSheet,
                                captureImage: $captureImage)
                        } else {
                            // UIImagePickerController（写真撮影） を表示
                            ImagePickerView(
                                isShowSheet: $isShowSheet,
                                captureImage: $captureImage)
                        }
                    }
                    
                } // 「画像を選択」ボタンのsheetここまで
                //Text(ownProfile.profile.userName)

                Text("プレーヤー名")
                    .font(.system(size: 22))
                //Text("ID: " + ownProfile.userId)
                Text("ID: aaaaaaaaaaaaa")
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(InAppColor.mainColor2)
            //.clipped()
        }
    }
    
    struct ListNameView: View {
        @ObservedObject private var ownProfile = Owner.sProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = Owner.sProfile.userId
        
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
                        Task {
                            try await ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                            //TODO:
                            self.presentation.wrappedValue.dismiss()
                        }
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
        @ObservedObject private var ownProfile = Owner.sProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = Owner.sProfile.userId
        
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
                    Task {
                        try await ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                        //TODO:
                        self.presentation.wrappedValue.dismiss()
                    }
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
        private var ownProfile = Owner.sProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = Owner.sProfile.userId
        
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
                    Task {
                        try await ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                        //TODO:
                        self.presentation.wrappedValue.dismiss()
                    }
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
        @ObservedObject private var ownProfile = Owner.sProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = Owner.sProfile.userId
        
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
                        Task {
                            try await ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                            //TODO:
                            self.presentation.wrappedValue.dismiss()
                        }
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
        @ObservedObject private var ownProfile = Owner.sProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = Owner.sProfile.userId
        
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
                        Task {
                            try await ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                            //TODO:
                            self.presentation.wrappedValue.dismiss()
                        }
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
        private var ownProfile = Owner.sProfile
        @State private var bufProfile = Profile()
        @State private var bufUserId: String = Owner.sProfile.userId
        
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
                        Task {
                            try await ownProfile.saveProfile(uId: bufUserId, prof: bufProfile, img: ownProfile.image)
                            //TODO:
                            self.presentation.wrappedValue.dismiss()
                        }
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

