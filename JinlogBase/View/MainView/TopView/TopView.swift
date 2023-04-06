//
//  TopView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/09.
//

import SwiftUI
//import Charts


struct TopView: View {
    
    //画面の初期設定
    init(){
        //タブバーの背景色を変更する
        //UITabBar.appearance().backgroundColor = UIColor(InAppColor.buttonColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(.gray)
        //UITabBar.appearance().unselectedItemTintColor = .lightGray
    }
    
    @State var selectTabIndex = 0
    @State var opacity :Double = 0
    
    
    var body: some View {
        
        ZStack{
            //背景色　ダークモード対応のため色はAssetsに登録
            //InAppColor.backColor
            //.edgesIgnoringSafeArea(.all)
            
            
            //TabViewの宣言部
            //タブ毎に画面(View)が1つ必要になる
            //タブのアイコンは「SF Symbols」っていうソフトでデフォルトで使えるアイコンが確認できる。
            
            TabView(selection: $selectTabIndex) {
                TabPage1View().tag(0)
                    .tabItem{
                        Image(systemName: "house.fill")
                        Text("ホーム")
                    }
                
                TabPage2View().tag(1)
                    .tabItem{
                        Image(systemName: "calendar")
                        Text("イベント")
                    }
                //.badge(newEvent > 0 ? "New" : nil)
                
                TabPage3View().tag(2)
                    .tabItem{
                        Image(systemName: "gamecontroller")
                        Text("ゲーム")
                    }
                
                TabPage4View().tag(3)
                    .tabItem{
                        Image(systemName: "message.fill")
                        Text("チャット")
                    }
                //.badge(unRead > 0 ? "\(unRead)" : nil)
                
                TabPage5View().tag(4)
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
    @State var num = 45
    let characters = ["長所探し","気遣い","ユーモア","話術","推理力"]
    
    
    var body: some View {
        
        VStack {
            Text("ステータス情報").font(.system(size: 22))
                .padding()
                .frame(maxWidth: .infinity)
                .background(InAppColor.accent1)
                .clipped()
                .shadow(radius: 5)
            
            ScrollView {
                ZStack {
                    //背景色　ダークモード対応のため色はAssetsに登録
                    InAppColor.mainColor1
                    
                    VStack {
                        RadarChartView(width: 320,
                                       MainColor: Color.init(white: 0.6),
                                       SubtleColor: Color.init(white: 0.7),
                                       quantity_incrementalDividers: 3,
                                       dimensions: MakeDimensions(),
                                       data: MakeDataPoint())
                        
                        //プログレスバーはviewで作成　　スタックで重ねて表示させる
                        //HStack {
                        SquareProgressView(maxNum: $maxNum, num: $num)
                            .frame(width: 250, height: 30)
                            .cornerRadius(15)
                        //Stepper("ステータス",value: $num, in: 0...100)
                        //.labelsHidden()
                        //}
                            .offset(y: -30)
                    }
                }
                        
                VStack {
                    ForEach(0..<personalityData.count, id: \.self) { num in
                        VStack {
                            if personalityData[num].display {
                                HStack {
                                    Text(personalityData[num].rayCase.rawValue)
                                        .padding(.leading, 100)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(String(format: "%.1f", personalityData[num].point))
                                        .font(.system(size: 20))
                                        .padding(.trailing, 100)
                                }
                                Divider()
                            }
                        }
                        
                    } //HStack
                } //Vstack
                
            }
        } //ScrollView
        .edgesIgnoringSafeArea(.all)
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
        GameView()
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
    
    var body: some View {
        
        //TODO: 実行時にエラーログが出る
        //※動作はちゃんとしてるっぽい？
        NavigationView{
            
            List{
                
                //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
                //　本当は　NavigationList　を入れるところだけど
                //　まだ画面ができてないので　Text　で仮に作成してます
                //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
                
                Section(header:Text("プロフィール")) {
                    
                    NavigationLink("プロフィール編集", destination: ProfileView2())
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
                    
                    NavigationLink("お気に入りプレイヤー",destination: PlayerList())
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
                            Task {
                                try! Owner.sAuth.signOut()
                                withAnimation(.linear(duration: 0.4)) {
                                    ReturnViewFrags.returnToLoginView.wrappedValue.toggle()
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
        TabPage3View()
        //        TabPage4View()
        TabPage5View()
    }
}
