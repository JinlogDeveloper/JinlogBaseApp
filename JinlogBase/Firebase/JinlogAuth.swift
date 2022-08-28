//
//  JinlogAuth.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/07/09.
//

import Foundation
import FirebaseAuth



actor FirebaseAuth {


    //-------------------------------------------------------------------------------------------
    //サインイン処理
    //　　引数：メールアドレス、パスワード
    //　　返り値：0　⇢　成功／-1　⇢　失敗
    //　　処理：引数で指定された情報でログインの処理を行う

    //　　■残作業：エラー処理がまだ追加できていない
    
    
    func SignIn(email: String, password: String) async -> Int{
        print("サインイン処理を実行\nemail:\(email)\npassword:\(password)")
        
        do{
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            
            print("login success")
            return 0
            
        } catch let signInError as NSError{
    
            print("login falre: %@" ,signInError)
            return -1
            
        }
    }


    //-------------------------------------------------------------------------------------------
    //サインアウト処理
    //　　引数：なし
    //　　返り値：0　⇢　成功／-1　⇢　失敗
    //　　処理：サインアウトの処理を行う
    
    //　　■残作業：エラー処理がまだちゃんと追加できていない


    func SignOut() -> Int{
        print("サインアウト処理を実行")
        
        do {
            try Auth.auth().signOut()
            return 0
            
        } catch let signOutError as NSError {
            print("ログアウトエラー: %@",signOutError)
            return -1
        }
    }

    
    //-------------------------------------------------------------------------------------------
    //新しいアカウントの登録
    //　　引数：メールアドレス、パスワード、アカウント名
    //　　返り値：なし
    //　　処理：引数で指定された情報で新しいアカウントの作成を行う
    
    //　　■残作業：エラー処理がまだ追加できていない
    
    
    func CreateAccount(email: String, password: String, name: String) async -> Int{

        print("アカウント作成処理を実行\nemail:\(email)\npassword:\(password)")
        
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            //アカウント情報変更のリクエストを出してユーザー名を登録する
            //createProfileChangeRequest()でアカウント情報の更新ができる
            
            //ちなみにAuthenticationには以下の情報がデフォルトで登録できるようになってる
            //  　email:             /** Emailアドレス **/,
            //  　phoneNumber:       /** 電話番号 **/,
            //  　emailVerified:     /** boolean Emailアドレスの確認の有無 **/,
            //  　password:          /** パスワード **/,
            //  　displayName:       /** ユーザーの表示名 **/,
            //  　photoURL:          /** ユーザーの写真 URL **/,
            //  　disabled:          /** ユーザーが無効かどうか **/
            
            
            let req = result.user.createProfileChangeRequest()
            req.displayName = name  // ユーザー名を変更

            //変更内容を反映する
            let _ = try await req.commitChanges()
            
            //req.commitChanges(completion: { error in
            //    if error == nil {
            //        print("アカウント情報の更新完了")
            //    } else {
            //        print("アカウント情報の更新失敗")
            //    }
            //})
            
            return 0
        }
        catch{
            print("アカウント作成に失敗しました")
            return -1
        }
    }

    
    //-------------------------------------------------------------------------------------------
    //ユーザー情報が既存出ないか確認
    //　　引数：メールアドレス
    //　　返り値：0　⇢　存在なし／1　→　重複あり／-1　⇢　失敗
    //　　処理：
    
 
    func CheckUserExists(email :String ,alert :inout Bool) async -> Int{
        
        print("アカウント情報がすでに存在しないか確認する")
        
        
        //？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
        // 登録済みのアドレスかどうか判断する専用のメソッドがないので、
        // サインイン方法を確認するメソッドを流用する

        //  どっかのタイミングでまた検討する

        //？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？

        do{
            //サインイン方法を確認するメソッドで既に登録があるか確認する
            let result = try await Auth.auth().fetchSignInMethods(forEmail: email)
            
            //返り値に何か情報が入っていれば既存のメールアドレス
            if(result != []){
                alert = true
                return 1
            }
            //情報が入ってなければ未登録
            else { return 0 }
        }
        catch let error as NSError{
            print("エラー発生: %@" ,error)
            alert = true
            return -1
        }
    }

    
    //-------------------------------------------------------------------------------------------
    //パスワードの再設定処理

    //ユーザー情報が既存出ないか確認
    //　　引数：メールアドレス
    //　　返り値：0　⇢　送信成功／-1　⇢　失敗
    //　　処理：

    func PasswordReset(email: String) async {
        print("パスワードの再設定処理\nメール送付先:\(email)")
        
        do{
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
        catch let error as NSError{
            print("エラー発生: %@" ,error)
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------
    //ログイン状態の取得
    //　　引数：なし
    //　　返り値：bool値（ログイン状態ならtrue、それ以外はfalseを返す）
    //　　処理：ログイン状態を確認して状態をBool値で返す
    
 
    func GetLoginState() -> Bool{
        print("ログイン状態を確認する")
        
        
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    
    //-------------------------------------------------------------------------------------------
    //アカウント情報の取得
    //　　引数：なし
    //　　返り値：なし
    //　　処理：ログインしているアカウントの情報を共通変数へ書き込む
    
 
    func GetAccountName() -> String{
        print("アカウント情報を取得する")
        
        guard let userName = Auth.auth().currentUser?.displayName else {return ""}
        
        return userName
    }
}

