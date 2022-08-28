//
//  NewAccountView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/05.
//

import SwiftUI


/// 新規アカウント登録の１画面目
///  - Note: メールアドレス、パスワードを入力
struct NewAccountView: View {
    
    @Binding var moveToTopView :Bool                //Top画面への遷移フラグ
    @State var moveToNewAccoutView2 = false         //次の画面への遷移フラグ
    @State var bufProfile :Profile = Profile()      //入力するプロフィール情報の格納
    @State var alertFlag = false                    //アラート画面の表示条件
    @State var errMessage = "エラー"                      //エラーメッセージ表示用
    
    private let firebaseAuth = FirebaseAuth()        //firebaseのインスタンス

    //dismissは現在の画面を閉じるときに使用する
    @Environment (\.dismiss) var dismiss
    
    
    //画面の本体部分
    var body: some View {
        
        ZStack {
            //背景
            LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            //次の登録画面への画面遷移
            NavigationLink(destination: NewAccountView2(moveToTopView: $moveToTopView, bufProfile: $bufProfile),
                           isActive: $moveToNewAccoutView2){
                EmptyView()     //画面には何も表示しない
            }
            
            VStack{
                Spacer().frame(height: 20)
                
                //タイトル部分
//                Text("JINLOG")
//                    //.padding()
//                    .foregroundColor(InAppColor.strColor)
//                    .font(.system(size: 40, weight: .thin))
                VStack {
                    Text("アカウント作成")
                        .padding(30)
                        .font(.system(size: 30).bold())
                        .foregroundColor(InAppColor.strColor)
                    
                    Text("JINLOGへようこそ!\n新規登録して利用を開始しましょう。")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 400)
                    
                    Divider()
                }
                
                Spacer()

                Text(errMessage)
                    .foregroundColor(.red.opacity(0.7))
                    .hidden()

                //入力フォーム部分
                VStack(spacing: 15.0){
                    TextFieldRow(fieldText: $bufProfile.emailAddress, iconName: "envelope",
                                 iconColor: InAppColor.buttonColor, text: "メールアドレス")

                    SecureFieldRow(fieldText: $bufProfile.password, iconName: "lock",
                                   iconColor: InAppColor.buttonColor, text: "パスワード")
                    
                    Text("※パスワードは半角英数字で6文字以上入力してください")
                        .padding(.horizontal, 30)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 400)
                }
                
                Spacer()
                
                Button(action: {
                    //とりあえず画面遷移だけさせる
                    moveToNewAccoutView2 = true
                    //　↓ 本番用はこっち
                    //CheckInputInfomation()
                }){
                    ButtonLabel(message: "アカウント登録", buttonColor: InAppColor.buttonColor)
                }
                .alert("いづれかのエラー\n未記入項目あり\nメールが登録済み\nエラー発生", isPresented: $alertFlag, actions: {})
                
                Button(action: {
                    dismiss()       // 1つ前の画面へ戻る
                }){
                    Text("戻る")
                        .padding()
                        .font(.title3)
                }
                
                Spacer().frame(height: 20)
            }//VStack
            //キーボード表示したときのツメツメ状態を回避
            .ignoresSafeArea(.keyboard, edges: .bottom)

        } //Zstack
        //NavigationViewで画面上部に無駄なスペースができるので削除,Backボタンも非表示
        .navigationBarHidden(true)
    }
    
    
    
    /// FirebaseAuthを検索して入力情報と重複がないか確認
    private func CheckInputInfomation() {

        if bufProfile.emailAddress.isEmpty {
            //メールアドレスの未入力エラー
            errMessage = "メールアドレスを入力してください。"
            alertFlag = true
            return
        }
        
        if bufProfile.password.count < 6 {
            //パスワードの入力エラー
            alertFlag = true
            return
        }
        
        Task{
            //Firebaseへアカウントを登録
            if(await firebaseAuth.CreateAccount(email: bufProfile.emailAddress,
                                                password: bufProfile.password,
                                                name: bufProfile.userName) == 0){
                //FirebaseAuthでログイン
                if(await firebaseAuth.SignIn(email: bufProfile.emailAddress,
                                             password: bufProfile.password) == 0){
                    //トップ画面へ一気に遷移する
                    moveToNewAccoutView2 = true
                }
            }
            else{ alertFlag = true }
        }
    }
} //View



struct NewAccountView_Previews: PreviewProvider {
    
    @State static var moveToTopView :Bool = false          //Top画面への遷移フラグ
    @State static var bufProfile :Profile = Profile()      //入力するプロフィール情報の格納
    
    static var previews: some View {
        NewAccountView(moveToTopView: $moveToTopView)
        //NewAccountView2(moveToMainView: $moveToTopView, bufProfile: $bufProfile)
    }
}
