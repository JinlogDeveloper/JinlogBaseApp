//
//  TopView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/09.
//

import SwiftUI
import Charts


struct TopView: View {
    
    //画面の初期設定
    init(){
        //タブバーの背景色を変更する
        //UITabBar.appearance().backgroundColor = UIColor(InAppColor.buttonColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(InAppColor.buttonColorRvs)
        //UITabBar.appearance().unselectedItemTintColor = .lightGray
    }
    
    @State var opacity :Double = 0
    
    
    var body: some View {
        
        ZStack{
            //背景色　ダークモード対応のため色はAssetsに登録
            //InAppColor.backColor
            //.edgesIgnoringSafeArea(.all)
            

            //TabViewの宣言部
            //タブ毎に画面(View)が1つ必要になる
            //タブのアイコンは「SF Symbols」っていうソフトでデフォルトで使えるアイコンが確認できる。
            
            TabView{
                TabPage1View()
                    .tabItem{
                        Image(systemName: "house.fill")
                        Text("ホーム")
                    }
                
                TabPage2View()
                    .tabItem{
                        Image(systemName: "calendar")
                        Text("イベント")
                    }
                //.badge(newEvent > 0 ? "New" : nil)
                
                TabPage3View()
                    .tabItem{
                        Image(systemName: "gamecontroller")
                        Text("ゲーム")
                    }
                
                TabPage4View()
                    .tabItem{
                        Image(systemName: "message.fill")
                        Text("チャット")
                    }
                //.badge(unRead > 0 ? "\(unRead)" : nil)
                
                TabPage5View()
                    .tabItem{
                        Image(systemName: "gearshape")
                        Text("設定")
                    }
            } //TabView
            .accentColor(InAppColor.buttonColor)
        } //ZStack
        .opacity(opacity)
        .onAppear(){
            withAnimation(.linear(duration: 0.6)){
                self.opacity = 1.0
            }
        }
        
    }
}



//ここから下は各タブで使用する画面のコード部分
struct TabPage1View: View {
    
    @State var maxNum = 100
    @State var num = 30
    @State var value :CGFloat = 0.3
    @State var score :[Double] = [3.5,4.8,2.5,3.5,2.8]
    
    var body: some View {
        
        ZStack{
            //背景色　ダークモード対応のため色はAssetsに登録
            InAppColor.backColor
                .edgesIgnoringSafeArea(.all)
            
            ScrollView{
                
                VStack{
                    
                    ZStack{
                        //Text("ステータス画面")
                        
                        //Circle()
                        //    .stroke(lineWidth: 30.0)
                        //    .opacity(0.1)
                        //    .foregroundColor(InAppColor.buttonColor)
                        //    .frame(width: UIScreen.main.bounds.width - 40,
                        //           height: UIScreen.main.bounds.width - 40 )
                        
                        //Circle()
                        //    .trim(from: 0.0, to: 0.3)
                        //    .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                        //    .foregroundColor(InAppColor.buttonColor)
                        //    .frame(width: UIScreen.main.bounds.width - 40,
                        //           height: UIScreen.main.bounds.width - 40)
                        //    .rotationEffect(Angle(degrees: -90))
                        //    .opacity(0.5)
                        
                        
                        //一旦ここにデータを作成。今後どっかへ移動させる
                        Radar(entries: [
                            RadarChartDataEntry(value: 2.6),
                            RadarChartDataEntry(value: 2.8),
                            RadarChartDataEntry(value: 4.1),
                            RadarChartDataEntry(value: 5.0),
                            RadarChartDataEntry(value: 3.4)]
                              ,entries2: [
                                RadarChartDataEntry(value: score[0]),
                                RadarChartDataEntry(value: score[1]),
                                RadarChartDataEntry(value: score[2]),
                                RadarChartDataEntry(value: score[3]),
                                RadarChartDataEntry(value: score[4])]
                        )
                        .frame(width: UIScreen.main.bounds.width,height: 400.0)
                        
                        VStack{
                            Spacer()
                                .frame(height:270)
                            
                            //プログレスバーはviewで作成　　スタックで重ねて表示させる
                            SquareProgressView(maxNum: $maxNum, num: $num)
                                .frame(width: 300, height: 40)
                                .cornerRadius(15)
                            
                        }
                    } //Zstack
                    .frame(width: UIScreen.main.bounds.width)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    VStack{
                        Stepper(value: $num, in: 0...100) {
                            Text("ステータス：\(num)")
                        }
                        .frame(width:UIScreen.main.bounds.width  - 80)
                        
                        Stepper(value: $score[0], in: 0...5, step: 0.5) {
                            Text("長所探し：\(String(score[0]))")
                        }
                        .frame(width:UIScreen.main.bounds.width  - 80)
                        
                        Stepper(value: $score[1], in: 0...5, step: 0.5) {
                            Text("気遣い：\(String(score[1]))")
                        }
                        .frame(width:UIScreen.main.bounds.width  - 80)
                        
                        Stepper(value: $score[2], in: 0...5, step: 0.5) {
                            Text("ユーモア：\(String(score[2]))")
                        }
                        .frame(width:UIScreen.main.bounds.width  - 80)
                        
                        Stepper(value: $score[3], in: 0...5, step: 0.5) {
                            Text("話術：\(String(score[3]))")
                        }
                        .frame(width:UIScreen.main.bounds.width  - 80)
                        
                        Stepper(value: $score[4], in: 0...5, step: 0.5) {
                            Text("推理力：\(String(score[4]))")
                        }
                        .frame(width:UIScreen.main.bounds.width  - 80)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.white)
                    .cornerRadius(15)
                } //Vstack
            }
        }
    }
}



struct TabPage2View: View {
    var body: some View {
        
        VStack{
            Text("2ページめのタブ")
                .font(.title)
            
        }
    }
}


struct TabPage3View: View {
    var body: some View {
        
        VStack{
            Text("3ページめのタブ")
                .font(.title)
            
        }
    }
}


struct TabPage4View: View {
    var body: some View {
        
        VStack{
            Text("4ページめのタブ")
                .font(.title)
            
        }
    }
}


struct TabPage5View: View {
    
    @State var permitComment = false
    @State var permitMessage = false
    @State var isShowDialog = false     //ダイアログボックスの表示フラグ
    
    let firebaseAuth :FirebaseAuth = FirebaseAuth()
    
    var body: some View {
        
            NavigationView{
                
                List{
                    
                    //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
                    //　本当は　NavigationList　を入れるところだけど
                    //　まだ画面ができてないので　Text　で仮に作成してます
                    //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
                    
                    Section(header:Text("プロフィール")) {
                        
                        Text("プロフィール編集")
                        Text("メールアドレス変更")
                        Text("パスワード変更")
                        Text("ステータス変更")
                        
                    }
                    
                    Section(header:Text("メッセージ・コメント")) {
                        
                        Toggle(isOn: $permitComment){
                            Text("コメントの許可")
                        }
                        
                        Toggle(isOn: $permitMessage){
                            Text("メッセージの許可")
                        }
                        
                    }
                    
                    Section(header:Text("プレーヤーリスト")) {
                        
                        Text("お気に入りプレイヤー")
                        Text("ブロックしたプレイヤー")
                        
                    }

                    Section(){
                        Button(action: {}){
                            Text("アカウント編集")
                                .foregroundColor(Color.red)
                        }
                    }
                } //List
                .navigationTitle(Text("設定"))
                //.navigationBarTitleDisplayMode(.inline)
                //.navigationBarHidden(true)
                .toolbar {
                    // ナビゲーションバー左にアイコン追加
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: { isShowDialog = true }) {
                            VStack{
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("ログアウト").font(.system(size: 10))
                            }
                        }
                        .confirmationDialog("ログアウト操作\n続行していいですか",
                                            isPresented: $isShowDialog,
                                            titleVisibility: .visible) {
                            Button("ログアウトする") {
                                Task{
                                    if(await firebaseAuth.SignOut() == 0){
                                        withAnimation(.linear(duration: 0.4)){
                                            ReturnViewFrags.returnToLoginView.wrappedValue = false
                                        }
                                    }
                                }
                            }
                            Button("キャンセル", role: .cancel) {}
                        }
                    }
                }
            } //NavigationView
    } //bodyView
} //View


struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
            .previewInterfaceOrientation(.portrait)
        //        TabPage1View()
        //        TabPage2View()
        //        TabPage3View()
        //        TabPage4View()
        TabPage5View()
    }
}
