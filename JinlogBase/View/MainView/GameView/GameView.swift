//
//  GameEntranceView.swift
//  JinlogBase
//
//  Created by MacBook Air M1 on 2022/09/18.
//

import SwiftUI

struct GameView: View {
    @ObservedObject private var gm = GameMaster()
    
    var body: some View {
        if gm.gameId.isEmpty {
            let _ = print("DEBUG : GameViewTop()")
            GameViewTop(gm: gm)
        } else {
            switch gm.gameState.progress.phase {
            case .recruitPlayers:
                if gm.gameState.hostUserId == Owner.sAuth.uid {
                    let _ = print("DEBUG : GameViewRecruitPlayers()")
                    GameViewRecruitPlayers(gm: gm)
                } else {
                    let _ = print("DEBUG : GameViewWaitingStart()")
                    GameViewWaitingStart(gm: gm)
                }
                
            case .confirmingTheRole:
                let _ = print("DEBUG : GameViewConfirmingRole()")
                GameViewConfirmingRole(gm: gm)
                
            case .discussion:
                let _ = print("DEBUG : GameViewDiscussion()")
                GameViewDiscussion(gm: gm)
                
            default:
                let _ = print("ERROR : EmptyView()")
                EmptyView()
            }
        }
    }
}

struct GameViewTop: View {
    @ObservedObject var gm: GameMaster
    
    @State private var inputGameId = ""
    
    var body: some View {
        VStack{
            Button("ゲームを作成する") {
                Task {
                    do {
                        try await gm.createGame(uId: Owner.sAuth.uid)
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }.padding()
            
            VStack {
                TextFieldRow(
                    fieldText: $inputGameId, 
                    iconName: "person.badge.plus", 
                    text: "Game ID"
                )
                
                Button("ゲームに参加する") {
                    Task {
                        do {
                            try await gm.joinGame(gId: inputGameId)
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
            }.padding()
            
        }
    }
}

struct GameViewRecruitPlayers: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("ゲーム参加者募集中")
                .font(.system(size: 31, weight: .thin))
            
            let qrCode: UIImage? = UIImage().createQRCode(sourceText: gm.gameId)
            if qrCode != nil {
                Image(uiImage: qrCode!)
                    .resizable()
                    .frame(width: 240, height: 240)
                    .overlay(   //楕円
                        Ellipse()
                            .fill(Color.green)
                            .frame(width: 100, height: 100)
                    )
                    .overlay(   //アイコン
                        Image(systemName: "tortoise.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                    )
            }
            Text("\(gm.gameId)")
            
            Text("現在の参加者数は \(gm.gamePlayers.count) 人です")
                .padding()
            
            Button("ゲームを開始する") {
                Task {
                    do {
                        try await gm.startGame()
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }.padding()
            
        }
    }
}

struct GameViewWaitingStart: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            VStack{
                Text("ゲームの開始を")
                    .font(.system(size: 31, weight: .thin))
                Text("待っています")
                    .font(.system(size: 31, weight: .thin))
            }.padding()
            
            Text("ゲームID")
            Text("\(gm.gameId)")
            
            Text("現在の参加者数は \(gm.gamePlayers.count) 人です")
                .padding()
            
            Button("ゲームから抜ける") {
                Task {
                    do {
                        try await gm.leaveGame(uId: Owner.sAuth.uid)
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }.padding()
        }
    }
}

struct GameViewConfirmingRole: View {
    @ObservedObject var gm: GameMaster
    @State private var allConfirmed: Bool = false
    
    var body: some View {
        VStack{
            let player = gm.gamePlayers.first(
                where: {$0.userId == Owner.sAuth.uid}
            )
            if (player != nil) {
                
                if (gm.gameState.hostUserId == Owner.sAuth.uid) &&
                    (gm.gamePlayers.filter({$0.confirmedRole}).count == gm.gamePlayers.count) {
                    // 全員が役職を確認したら議論フェーズへ
                    // ※主催者スマホに処理させる
                    Text("全員が役職を確認しました").padding()
                    Button("議論を開始する") {
                        Task {
                            do {
                                try await gm.startDiscussion()
                            } catch {
                                //TODO:
                                print("ERROR")
                            }
                        }
                    }.padding()
                } else {
                    
                    Text("あなたの役職は \(player!.role.name) です")
                        .padding()
                    
                    if player!.confirmedRole == false {
                        Button("確認しました") {
                            Task {
                                do {
                                    try await gm.confirmRole(uId: Owner.sAuth.uid)
                                } catch {
                                    //TODO:
                                    print("ERROR")
                                }
                            }
                        }.padding()
                    } else {
                        Text("役職を確認済み").padding()
                        Text("しばらくお待ちください").padding()
                    }                       
                    
                }
            }else {
                Text("えらー").padding()
                //TODO:
            }
            
        }
    }
}

struct GameViewDiscussion: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("〜議論中〜")
                .font(.system(size: 31, weight: .thin))
                .padding()
            Text("残り時間 **分 **秒")
                .font(.system(size: 31, weight: .thin))
                .padding()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameViewTop(gm: GameMaster())
        GameViewRecruitPlayers(gm: GameMaster())
        GameViewWaitingStart(gm: GameMaster())
        GameViewConfirmingRole(gm: GameMaster())
        GameViewDiscussion(gm: GameMaster())
    }
}
