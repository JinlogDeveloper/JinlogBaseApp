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
            
            //TODO: 要デバッグ
            let own = gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})
            if own != nil {
                if own?.alived == false {
                    GameViewGameOver(gm: gm)
                }
            }

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
                
            case .voting:
                let _ = print("DEBUG : GameViewVoting()")
                GameViewVoting(gm: gm)
                
            case .annouceVoteResult:
                let _ = print("DEBUG : GameViewVoteResult()")
                GameViewVoteResult(gm: gm)
                
            case .dayResult:
                let _ = print("DEBUG : GameViewDayResult()")
                GameViewDayResult(gm: gm)

            case .werewolf:
            let _ = print("DEBUG : GameViewWerewolf()")
            GameViewWerewolf(gm: gm)

            case .attackResult:
            let _ = print("DEBUG : GameViewAttackResult()")
            GameViewAttackResult(gm: gm)


            default:
                let _ = print("ERROR : EmptyView()")
                EmptyView()
            }
        }
    }
}

struct GameViewTop: View {
    @ObservedObject var gm: GameMaster
    
    @ObservedObject var qrcodeScannerSetting = QRCodeScannerSetting()
    
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
                
                HStack{
                    Button(action:{
                        print("QRcordを読み取るカメラ起動")
                        qrcodeScannerSetting.isShowing = true
                        
                    },label:{
                        Image(systemName: "person.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25.0, height: 25.0)
                        
                    })
                    
                    TextField("Game ID",text: $inputGameId)
                }
                .padding(12.0)
                .frame(maxWidth: 400)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 3)
                .padding(.horizontal, 20.0)
                
                
                
                
                Button("ゲームに参加する") {
                    Task {
                        do {
                            try await gm.joinGame(gId: inputGameId, uId: Owner.sAuth.uid)
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
                .fullScreenCover(isPresented: $qrcodeScannerSetting.isShowing) {
                    QRCodeScannerView(qrcodeScannerSetting: qrcodeScannerSetting)
                }
                
                
            }.padding()
            
        }.onChange(of: qrcodeScannerSetting.qrcodeString){ newValue in
            inputGameId = newValue
        }
    }
}

struct GameViewRecruitPlayers: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("ゲーム参加者募集中")
                .font(.system(size: 31, weight: .thin))
            
            //TODO: メソッドで作る
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
                } else {
                    
                    Text("あなたの役職は \(player?.role.name ?? "村人") です")
                        .padding()
                    
                    if player?.confirmedRole == false {
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
            } else {
                Text("えらー").padding()
                //TODO:
            }
            
        }
        .onChange(of: gm.gamePlayers) { players in
            // 全員が役職を確認したら議論フェーズへ
            // ※主催者スマホに処理させる
            print("onChange()")
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                print("owner")
                let alivedUserNum = players.filter({$0.alived}).count
                let alivedConfirmedUserNum = players.filter({$0.alived && ($0.confirmedRole)}).count
                print("alivedUserNum:\(alivedUserNum) alivedConfirmedUserNum:\(alivedConfirmedUserNum)")
                
                if alivedUserNum == alivedConfirmedUserNum {
                    Task {
                        do {
                            try await gm.startDiscussion()
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
            }
        }
    }
}

struct GameViewDiscussion: View {
    @ObservedObject var gm: GameMaster
    
    @State private var timerCount: Int = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack{
            Text("〜議論中〜")
                .font(.system(size: 31, weight: .thin))
                .padding()
            Text("残り時間 \(timerCount/60)分 \(timerCount%60)秒")
                .font(.system(size: 31, weight: .thin))
                .padding()
        }
        .onAppear() {
            timerCount = gm.gameState.progress.phaseTimer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                runEveryInterval()
            }
        }
    }
    
    func runEveryInterval() {
        if 0 < timerCount {
            timerCount -= 1
        } else {
            timer?.invalidate() // タイマ削除
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                Task {
                    do {
                        try await gm.startVote()
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }
        }
    }
}

struct GameViewVoting: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("投票画面")
                .font(.system(size: 31, weight: .thin))
                .padding()
            
            let own = gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})
            if own == nil {
                //TODO error
                EmptyView()
            } else if own?.voteUserId == "" {
                // 未投票
                beforeVote(gm: gm)
            } else {
                // 投票済
                afterVote(gm: gm)
            }
            
        }
        .onChange(of: gm.gamePlayers) { players in
            // 全員が投票したら投票結果発表フェーズへ
            // ※主催者スマホに処理させる
            print("onChange()")
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                print("owner")
                let alivedUserNum = players.filter({$0.alived}).count
                let alivedVotedUserNum = players.filter({$0.alived && ($0.voteUserId != "")}).count
                print("alivedUserNum:\(alivedUserNum) alivedVotedUserNum:\(alivedVotedUserNum)")
                
                if alivedUserNum == alivedVotedUserNum {
                    Task {
                        do {
                            try await gm.startAnnounceVoteResult()
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
            }
        }
    }
    
    struct beforeVote: View {
        @ObservedObject var gm: GameMaster
        
        var body: some View {
            VStack {
                Text("投票先を選んでください").padding()
                
                List {
                    ForEach(gm.gamePlayers, id: \.self) { player in
                        if (player.userId != Owner.sAuth.uid) && (player.alived) {
                            // 本人以外の生存者
                            Button(player.userId) {
                                //TODO: 「投票先はこの人でいいですか？はい/いいえ」的な確認ダイアログ表示
                                Task {
                                    do {
                                        try await gm.vote(uId: Owner.sAuth.uid, voteForId: player.userId)
                                    } catch {
                                        //TODO:
                                        print("ERROR")
                                    }
                                }
                            }
                        } else {
                            if player.userId == Owner.sAuth.uid {
                                Text(player.userId).background(Color.blue)  // 本人
                            } else {
                                Text(player.userId).background(Color.gray)  // 既死者
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    struct afterVote: View {
        @ObservedObject var gm: GameMaster
        
        var body: some View {
            
            let own = gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})
            if own == nil {
                //TODO error
                EmptyView()
            } else {
                
                VStack {
                    Text("投票先 選択済み").padding()
                    Text("しばらくお待ちください").padding()
                    
                    List {
                        ForEach(gm.gamePlayers, id: \.self) { player in
                            if player.userId == Owner.sAuth.uid {
                                Text(player.userId).background(Color.blue)      // 本人
                            } else if player.alived == false {
                                Text(player.userId).background(Color.gray)      // 既死者
                            } else if player.userId == own?.voteUserId {
                                Text(player.userId).background(Color.red)       // 投票先
                            } else {
                                Text(player.userId)                             // それ以外
                            }
                        }
                    }
                    
                }

            }
        }
    }
    
}

struct GameViewVoteResult: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("投票結果")
                .font(.system(size: 31, weight: .thin))
                .padding()

            Text("追放者が決定しました").padding()
            let mostVotedUserId = gm.getMostVotedUser()
            ForEach(mostVotedUserId, id: \.self) { userId in
                Text(userId)
            }

            if let _ = mostVotedUserId.first(where: {$0 == Owner.sAuth.uid}) {
                Text("あなたは追放されました").padding()
                if gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})?.alived == true {
                    Button("立ち去る") {
                        Task {
                            do {
                                try await gm.lieveVillage(uId: Owner.sAuth.uid)
                            } catch {
                                //TODO:
                                print("ERROR")
                            }
                        }
                    }
                } else {
                    Text("ゲームオーバー")
                }
            }

        }
        .onChange(of: gm.gamePlayers) { players in
            // 追放者が立ち去ったら昼結果を判定
            // ※主催者スマホに処理させる
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                let mostVotedUserId = gm.getMostVotedUser()

                var isFinishedLeaving: Bool = true
                for i in 0 ..< mostVotedUserId.count {
                    // 追放者がまだ立ち去ってなければfalse
                    if gm.gamePlayers.first(where: {$0.userId == mostVotedUserId[i]})?.lievedVillage == false {
                        isFinishedLeaving = false
                    }
                }
                // 追放者が全員立ち去っていればtrueが残る

                if isFinishedLeaving == true {
                    Task {
                        do {
                            try await gm.judgeDayResult()
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }

            }
        }

    }
}

struct GameViewDayResult: View {
    @ObservedObject var gm: GameMaster
    @State private var isWerewolfAlived: Bool = false
    
    var body: some View {
        
        VStack{
            Text("結果発表")
                .font(.system(size: 31, weight: .thin))
                .padding()
            
            if isWerewolfAlived == false {
                Text("市民の勝ち！").padding()
            } else {
                Text("人狼の勝ち！").padding()
            }

            Button("ゲーム終了") {
                gm.reInit()
            }.padding()
            
        }
        .onAppear() {
            // 人狼の生死確認
            for i in 0 ..< gm.gamePlayers.count {
                if gm.gamePlayers[i].alived == true {
                    if gm.gamePlayers[i].role == .Werewolf {
                        print("isWerewolfAlived = true")
                        isWerewolfAlived = true
                    }
                }
            }
        }

    }
}

struct GameViewWerewolf: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("〜人狼活動フェーズ〜")
                .font(.system(size: 31, weight: .thin))
                .padding()
            
            let own = gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})
            if own == nil {
                //TODO error
                EmptyView()
            } else if own?.role == .Werewolf {
                // 襲撃先選択画面
                chooseVictim(gm: gm)
            } else {
                // 人狼以外
                Text("人狼が活動中です。").padding()
                Text("しばらくお待ちください。").padding()
            }
            
        }
        .onChange(of: gm.gamePlayers) { players in
            // 襲撃先が決定したら襲撃結果発表フェーズへ
            // ※主催者スマホに処理させる
            print("onChange()")
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                print("owner")
                let alivedWerwolfNum = players
                    .filter(
                        {$0.alived && ($0.role == .Werewolf)}
                    ).count
                let alivedWerwolfAttackedNum = players
                    .filter(
                        {$0.alived && ($0.role == .Werewolf) && !($0.atackUserId.isEmpty)}
                    ).count

                if alivedWerwolfNum == alivedWerwolfAttackedNum {
                    Task {
                        do {
                            try await gm.startAnnounceAttackResult()
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
            }
        }
    }
    
    struct chooseVictim: View {
        @ObservedObject var gm: GameMaster
        
        var body: some View {
            VStack {
                Text("襲撃先を選んでください").padding()
                
                List {
                    ForEach(gm.gamePlayers, id: \.self) { player in
                        if (player.role != .Werewolf) && (player.alived) {
                            // 人狼以外の生存者
                            Button(player.userId) {
                                Task {
                                    do {
                                        try await gm.attack(uId: Owner.sAuth.uid, attackForId: player.userId)
                                    } catch {
                                        //TODO:
                                        print("ERROR")
                                    }
                                }
                            }
                        } else {
                            if player.alived == false {
                                Text(player.userId).background(Color.gray)  // 既死者
                            } else {
                                Text(player.userId).background(Color.blue)  // 人狼
                            }
                        }
                    }
                }

            }
        }
    }
    
}

struct GameViewAttackResult: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("襲撃結果")
                .font(.system(size: 31, weight: .thin))
                .padding()

            Text("犠牲者が発生しました").padding()
            let attackedUserId = gm.getAttackedUser()
            ForEach(attackedUserId, id: \.self) { userId in
                Text(userId)
            }

            if let _ = attackedUserId.first(where: {$0 == Owner.sAuth.uid}) {
                Text("あなたは人狼に襲撃されました").padding()
                if gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})?.alived == true {
                    Button("OK") {
                        Task {
                            do {
                                try await gm.lieveVillage(uId: Owner.sAuth.uid)
                            } catch {
                                //TODO:
                                print("ERROR")
                            }
                        }
                    }
                } else {
                    Text("ゲームオーバー")
                }
            }

        }
        .onChange(of: gm.gamePlayers) { players in
            // 犠牲者が確認したら夜結果判定
            // ※主催者スマホに処理させる
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                let attackedUserId = gm.getAttackedUser()

                var isFinishedLeaving: Bool = true
                for i in 0 ..< attackedUserId.count {
                    // 犠牲者がまだ確認してなければfalse
                    if gm.gamePlayers.first(where: {$0.userId == attackedUserId[i]})?.lievedVillage == false {
                        isFinishedLeaving = false
                    }
                }
                // 犠牲者が全員確認済みならばtrueが残る

                if isFinishedLeaving == true {
                    Task {
                        do {
                            try await gm.judgeNightResult()
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }

            }
        }

    }
}

struct GameViewGameOver: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("ゲームオーバー")
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var dummyGM = GameMaster()
    
    static var previews: some View {
        let _ = dummyGM.setDummy()
        let _ = Owner.sAuth.setDummy()

        GameViewTop(gm: dummyGM)
        GameViewRecruitPlayers(gm: dummyGM)
        GameViewWaitingStart(gm: dummyGM)
        GameViewConfirmingRole(gm: dummyGM)
        GameViewDiscussion(gm: dummyGM)
        GameViewVoting(gm: dummyGM)
    }
    
}
