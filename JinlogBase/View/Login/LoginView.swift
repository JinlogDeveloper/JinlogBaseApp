//
//  LoginView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/20.
//

import SwiftUI



extension AnyTransition {
    ///下からスライド表示するアニメーション
    static var bottomUp: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom))
    }
}


struct LoginView: View {
    
    @Binding var moveToTopView: Bool                //アプリトップ画面への遷移条件フラグ
    @State var emailAddress :String = ""            //メールアドレス用、view側のTextFieldと連携
    @State var password :String = ""                //パスワード用、view側のTextFieldと連携
    @State var moveToCreateAccountView = false      //新規アカウント作成画面への遷移条件フラグ
    @State var moveToResetPassView = false          //パスワードリセット画面への遷移条件フラグ
    
    let firebaseAuth :FirebaseAuth = FirebaseAuth()

    
    var body: some View {
        NavigationView{
            
            ZStack{
                // 背景色　ダークモード対応のため色はAssetsに登録
                LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topTrailing, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                // 新規アカウント画面への遷移
                NavigationLink(destination: NewAccountView(moveToTopView: $moveToTopView),
                               isActive: $moveToCreateAccountView){
                    EmptyView()
                }
                
                VStack{
                    Spacer()
                    
                    // タイトル部分
                    Text("JINLOG")
                        .padding()
                        .foregroundColor(InAppColor.strColor)
                        .font(.system(size: 80, weight: .thin))
                    
                    Spacer()
                    
                    VStack(spacing: 15.0){
                        //メール & パスワード入力フォーム
                        TextFieldRow(fieldText: $emailAddress, iconName: "person", iconColor: InAppColor.buttonColor, text: "Email")
                        SecureFieldRow(fieldText: $password, iconName: "lock", iconColor: InAppColor.buttonColor, text: "Password")
                        
                        Spacer().frame(height: 15)
                        
                        //ログインボタン
                        Button(action: {


                            //----------------  一旦コメントにする  ----------------
                            // FirebaseAuth を使うとエラーになるので一旦コメント化する
                            // Authのバージョンだけ古い？　確認が必要
                            
                            
//                            Task{
//                                if(await firebaseAuth.SignIn(email: emailAddress, password:password) == 0){
                                    //ログイン成功時にテキストフィールドの値は削除
                                    emailAddress = ""
                                    password = ""
                                    //どこからでもトップ画面へ戻れるように遷移のフラグを共通変数で保持
                                    ReturnViewFrags.returnToLoginView = $moveToTopView
                                    //トップ画面へ遷移
                                    moveToTopView.toggle()
//                                }
//                            }
                            //---------------------  ここまで  ---------------------
                            
                               
                        }){
                            ButtonLabel(message: "ログイン", buttonColor: InAppColor.buttonColor)
                        }
                        
                        //新規アカウント作成ボタン
                        Button(action: {
                            //どこからでもトップ画面へ戻れるように遷移のフラグを共通変数で保持させる
                            ReturnViewFrags.returnToLoginView = $moveToCreateAccountView
                            //アカウント登録画面へ移動
                            moveToCreateAccountView = true
                        }){
                            ButtonLabel(message: "アカウント作成", buttonColor: InAppColor.buttonColor2)
                        }
                        
                        Spacer().frame(height: 5)
                        
                        //パスワード変更時の処理
                        Button(action: {
                            //下からのスライドアニメーションを付与
                            withAnimation(.easeInOut(duration: 0.5)){
                                moveToResetPassView.toggle()
                            }
                        }){
                            Text("パスワードを忘れた場合")
                                .foregroundColor(InAppColor.strColor)
                                .underline()
                        }
                    }
                    
                    Spacer()
                    
                }//VStack
                //キーボードによる画面圧迫を防止
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                //パスワード変更用の画面
                if moveToResetPassView {
                    PasswordResetDetail(showView: $moveToResetPassView)
                        .transition(.bottomUp)
                }
            } //Zstack
            .navigationBarHidden(true)
        } //NavigationView
        .onAppear(){
            
            
            //----------------  一旦コメントにする  ----------------
            // FirebaseAuth を使うとエラーになるので一旦コメント化する
            // Authのバージョンだけ古い？　確認が必要

//            Task{
//                if( await firebaseAuth.GetLoginState()){
//                    //トップ画面遷移のフラグを紐付け
//                    ReturnViewFrags.returnToLoginView = $moveToTopView
//                    //トップ画面へ遷移させる
//                    moveToTopView.toggle()
//                }
//            }
            //---------------------  ここまで  ---------------------

            
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    @State static var moveView = false
    
    static var previews: some View {
        LoginView(moveToTopView: $moveView)
    }
}
