//
//  GameMaster.swift
//  JinlogBase
//
//  Created by MacBook Air M1 on 2022/09/15.
//

import Foundation


/// 役職
enum GameRole: Int, Codable {
    case nothing            = 0
    case Werewolf           = 1
    case Villager           = 2
    case FortuneTeller      = 3
    case Medium             = 4
    case Knight             = 5

    var name: String {
        switch self {
        case .nothing:          return "未決定"
        case .Werewolf:         return "人狼"
        case .Villager:         return "村人"
        case .FortuneTeller:    return "占い師"
        case .Medium:           return "霊媒師"
        case .Knight:           return "騎士"
        }
    }
}

/// ゲームフェーズ
enum GamePhase: Int, Codable {
    case nothing                = 0

    // ゲーム準備
    case recruitPlayers                 // プレイヤー募集中

    // ゲーム開始
    case confirmingTheRole              // 役職周知

    // 0日目
    case firstFortuneTeller             // 初日占い

    // n日目（昼）
    case discussion                     // 議論
    case voting                         // 投票
    case annouceVoteResult              // 投票結果発表
    case dayResult                      // ゲーム結果発表(昼)
    // n日目（夜）
    case medium                         // 霊媒師ターン
    case fortuneTeller                  // 占い師ターン
    case knight                         // 騎士ターン
    case werewolf                       // 襲撃ターン
    // n日目（翌朝）
    case attackResult                   // 襲撃結果発表
    case morningResult                  // ゲーム結果発表(朝)

    case closed                         // 終了したゲーム
}

/// 投票方法
enum GameVotingStyle: Int, Codable {
    case publish                    = 0             // 公開
    case nonPublish                 = 1             // 非公開
}

/// 同票時の対応方法
enum GameTieVotesStyle: Int, Codable {
    case allPunish                  = 0             // 全吊り
    case ramdomPunish               = 1             // ランダム吊り
    case allAlive                   = 2             // 全生存
    case reVoteTie                  = 3             // 同票者へ再投票
    case reVoteAll                  = 4             // 全員で再投票
}

/// ゲームルール
struct GameRule: Codable {
    var numOfWerewolves: Int        = 0             // 人数（人狼）
    var numOfVillagers: Int         = 0             // 人数（村人）
//    var numOfFortuneTellers: Int    = 0             // 人数（占い師）
//    var numOfMediums: Int           = 0             // 人数（霊媒師）
//    var numOfKnights: Int           = 0             // 人数（騎士）

//    var publicVote: Bool            = true          // 投票先公開有無
//    var FirstDivination: Bool       = false         // 初日占い有無
//    var continueGuard: Bool         = false         // 連続ガード可否
//    var discussTimePerPlayers: Int  = 0             // 一人あたりの議論時間[s]
    var minDiscussTime: Int         = 0             // 最低議論時間[s]
}

/// ゲーム進捗
struct GameProgress: Codable {
    var days: Int                   = 0             // 経過日数
    var phase: GamePhase            = .nothing      // フェーズ
    var phaseTimer: Int             = 0             // フェーズの残り時間
}


/// ゲーム状況
struct GameState: Codable {
    var hostUserId: String          = ""            // 主催者UID
    var rule = GameRule()                           // 設定
    var progress = GameProgress()                   // 進捗
}

/// ゲーム参加者
struct GamePlayer: Codable, Hashable {
    var userId: String              = ""            // UID
    var role: GameRole              = .nothing      // 役職
    var alived: Bool                = true          // 生存有無

    var confirmedRole: Bool         = false         // 役職認知有無
    var lievedVillage: Bool         = false         // 立ち去り有無
    var voteUserId: String          = ""            // 投票先UID
    var atackUserId: String         = ""            // 襲撃先UID
//    var divineUserId: String        = ""            // 占い先UID
//    var protectUserId: String       = ""            // 守り先UID
}


final class GameMaster: ObservableObject, DelegateGameListener {
    
    @Published private(set) var gameId: String = ""
    @Published private(set) var gameState = GameState()
    @Published private(set) var gamePlayers: [GamePlayer] = []
    
    private var gameStore = GameStore()
    
    func setDummy() {
        gameId = "abcdefg123abcdefg123"

        gameState.hostUserId = "abccdefg123456abccdefg123456"
        gameState.rule.numOfWerewolves  = 1
        gameState.rule.numOfVillagers   = 4
        gameState.rule.minDiscussTime   = 60
        gameState.progress.phaseTimer   = 75

        gamePlayers = []
        gamePlayers.append(GamePlayer(userId: "Player1_UID", role: .Villager, alived: true, confirmedRole: true, voteUserId: "Player4_UID"))
        gamePlayers.append(GamePlayer(userId: "Player2_UID", role: .Werewolf, alived: true, confirmedRole: true, voteUserId: "Player2_UID"))
        gamePlayers.append(GamePlayer(userId: "Player3_UID", role: .Villager, alived: false, confirmedRole: true, voteUserId: "Player1_UID"))
        gamePlayers.append(GamePlayer(userId: "Player4_UID", role: .Villager, alived: true, confirmedRole: true, voteUserId: "Player2_UID"))
        gamePlayers.append(GamePlayer(userId: "Player5_UID", role: .Villager, alived: true, confirmedRole: true, voteUserId: "Player2_UID"))
    }

    func reInit() {
        gameId = ""
        gameState = GameState()
        gamePlayers = []

        //TODO: deinitが呼ばれているかを確認すること！！
        gameStore = GameStore()
    }

    // DelegateGameListener
    @MainActor func receiveLatestGame(gId: String, latestGameState: GameState?) {
        if (gId == gameId) && (latestGameState != nil) {
            print("\(gameId) : \(latestGameState!)")
            gameId = gId
            gameState = latestGameState!
        } else {
            if gId != gameId {
                print("Error : gId(\(gId) does not match gameId(\(gameId))")
            }
            if latestGameState == nil {
                print("Error : latestGameState is nil")
            }
            //gameId = ""
            gameState = GameState()
        }
    }
    
    // DelegateGameListener
    @MainActor func receiveLatestGame(gId: String, latestGamePlayers: [GamePlayer]) {
        if gId == gameId {
            print("\(gameId) : \(latestGamePlayers)")
            gameId = gId
            gamePlayers = latestGamePlayers
        } else {
            if gId != gameId {
                print("Error : gId(\(gId) does not match gameId(\(gameId)")
            }
            //gameId = ""
            gamePlayers = []
        }
    }
    
    /// 新規ゲームを作成する
    @MainActor func createGame(uId: String) async throws {
        gameId = ""
        gameState = GameState()
        
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        
        // 新規ゲーム作成
        print("storeNewGame()")
        var bufGameState = GameState()
        bufGameState.hostUserId = uId
        bufGameState.progress.phase = .recruitPlayers
        let gId = try await gameStore.storeNewGame(game: bufGameState)
        
        // リアルタイム更新登録
        print("listenGame()")
        try await gameStore.listenGame(gameId: gId, listener: self)
        gameId = gId
        
        print("success createGame()  gameId : \(gameId)")
    }
    
    /// ゲームに参加する
    @MainActor func joinGame(gId: String, uId: String) async throws {
        //gameId = ""
        gameState = GameState()
        
        guard !(gId.isEmpty) else {
            print("Error : gId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        
        // ゲーム読み込み
        let bufGameState = try await gameStore.loadGameState(gameId: gId)
        
        // ゲームが募集中フェーズか確認
        guard bufGameState.progress.phase == .recruitPlayers else {
            print("the game is not recruiting")
            throw JinlogError.unexpected    //TODO: 募集中のゲームではないエラー
        }
        
        // プレイヤーをゲームに追加
        var newPlayer = GamePlayer()
        newPlayer.userId = uId
        try await gameStore.storeNewPlayer(gameId: gId, player: newPlayer)
        
        // リアルタイム更新登録
        print("listenGame")
        try await gameStore.listenGame(gameId: gId, listener: self)
        gameId = gId
        
        print("success joinGame()  gameId : \(gameId)")
    }
    
    @MainActor func leaveGame(uId: String) async throws {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }
        
        //TODO:
    }
    
    
    @MainActor func startGame() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }
        
        // ゲーム開始条件
        guard gameState.progress.phase == .recruitPlayers else {
            print("Error : phase(\(gameState.progress.phase))")
            throw JinlogError.unexpected
        }
        guard 2 <= gamePlayers.count else { //TODO: デバッグのため2にしてる
            print("Error : few players (\(gamePlayers.count)")
            throw JinlogError.unexpected    //TODO: 最小人数が集まってないエラー
        }
        // ・・・
        
        // 役職決定
        var bufPlayers = gamePlayers
        for i in 0 ..< bufPlayers.count {
            // とりあえず全部村人にして
            bufPlayers[i].role = .Villager
        }
        // 仮）ランダムな1人を人狼にする
        bufPlayers[Int.random(in: 0..<Int.max) % bufPlayers.count].role = .Werewolf
        
        //TODO: 現状playerひとりひとり順に保存。→TODO:playersをまとめて1回で保存にする。
        for i in 0 ..< bufPlayers.count {
            try await gameStore.updateGame(gameId: gameId, player: bufPlayers[i])
        }
        
        // フェーズ更新
        var bufState = gameState
        bufState.progress.phase = .confirmingTheRole
        try await gameStore.updateGame(gameId: gameId, game: bufState)
    }
    
    @MainActor func confirmRole(uId: String) async throws {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }
        
        // 役職認知
        var bufPlayers = gamePlayers
        guard let idx = bufPlayers.firstIndex(where: {$0.userId == uId}) else {
            print("Error : uId(\(uId) is not in this game")
            throw JinlogError.unexpected
        }
        bufPlayers[idx].confirmedRole = true
        
        // DB更新
        try await gameStore.updateGame(gameId: gameId, player: bufPlayers[idx])
    }

    //TODO: 
    @MainActor func startDiscussion() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }

        // フェーズ更新
        var bufState = gameState
        bufState.progress.phase = .discussion
        bufState.progress.phaseTimer = gamePlayers.filter({$0.alived}).count * 3   //TODO: 
        try await gameStore.updateGame(gameId: gameId, game: bufState)
    }

    //TODO: 
    @MainActor func startVote() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }

        // フェーズ更新
        var bufState = gameState
        bufState.progress.phase = .voting
        bufState.progress.phaseTimer = 0 
        try await gameStore.updateGame(gameId: gameId, game: bufState)
    }

    //TODO: 
    @MainActor func vote(uId: String, voteForId: String) async throws {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(voteForId.isEmpty) else {
            print("Error : voteForId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }
        
        // 投票
        var bufPlayers = gamePlayers
        guard bufPlayers.firstIndex(where: {$0.userId == voteForId}) != nil else {
            // 投票先UIDがこのゲームに登録されてない
            print("Error : uId(\(voteForId) is not in this game")
            throw JinlogError.unexpected
        }
        guard let idx = bufPlayers.firstIndex(where: {$0.userId == uId}) else {
            // 投票者がこのゲームに登録されてない
            print("Error : uId(\(uId) is not in this game")
            throw JinlogError.unexpected
        }
        bufPlayers[idx].voteUserId = voteForId
        
        // DB更新
        try await gameStore.updateGame(gameId: gameId, player: bufPlayers[idx])
    }

    //TODO: 
    @MainActor func startAnnounceVoteResult() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }

        // フェーズ更新
        var bufState = gameState
        bufState.progress.phase = .annouceVoteResult
        bufState.progress.phaseTimer = 0 
        try await gameStore.updateGame(gameId: gameId, game: bufState)
    }

    //TODO: 
    func getMostVotedUser() -> [String] {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            return []
        }

        struct VoteResultRecord {
            var userId: String = ""
            var votedCount: Int  = 0
        }

        // 得票数一覧作成
        var voteResults: [VoteResultRecord] = []
        for i in 0 ..< gamePlayers.count {
            voteResults.append(VoteResultRecord(userId: gamePlayers[i].userId))
            for j in 0 ..< gamePlayers.count {
                if voteResults[i].userId == gamePlayers[j].voteUserId {
                    voteResults[i].votedCount += 1
                }
            }
        }

        // 得票数が多い順に並び替え
        voteResults.sort(by: {$1.votedCount < $0.votedCount})

        // 最大得票者のUIDを抽出
        var mostVotedUserId: [String] = []
        for i in 0 ..< voteResults.count {
            if i == 0{
                // 得票数が多い順に並び替えてるので、一人目は確実に最大得票者
                mostVotedUserId.append(voteResults[i].userId)
            } else {
                if voteResults[i].votedCount == voteResults[i-1].votedCount {
                    // 二人目以降は、同得票数なら同率で最大得票者
                    mostVotedUserId.append(voteResults[i].userId)
                } else {
                    break
                }
            }
        }

        return mostVotedUserId
    }

    @MainActor func lieveVillage(uId: String) async throws {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }
        
        // 村から立ち去る
        var bufPlayers = gamePlayers
        guard let idx = bufPlayers.firstIndex(where: {$0.userId == uId}) else {
            print("Error : uId(\(uId) is not in this game")
            throw JinlogError.unexpected
        }
        bufPlayers[idx].lievedVillage = true
        bufPlayers[idx].alived = false
        
        // DB更新
        try await gameStore.updateGame(gameId: gameId, player: bufPlayers[idx])
    }

    // 昼の結果を判定し、夜へ移行 or ゲーム結果表示
    @MainActor func judgeDayResult() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }

        // 生存者数
        var alivedWerewolvesCount: Int = 0
        var alivedHumansCount: Int = 0
        for i in 0 ..< gamePlayers.count {
            if gamePlayers[i].alived == true {
                if gamePlayers[i].role == .Werewolf {
                    alivedWerewolvesCount += 1
                } else {
                    alivedHumansCount += 1
                }
            }
        }
        
        // 襲撃先UID初期化
        var bufPlayers = gamePlayers
        for i in 0 ..< bufPlayers.count {
            bufPlayers[i].atackUserId = ""
            try await gameStore.updateGame(gameId: gameId, player: bufPlayers[i])
        }

        // フェーズ更新
        var bufState = gameState
        if (alivedWerewolvesCount == 0) || (alivedHumansCount <= alivedWerewolvesCount) {
            // ゲーム終了
            bufState.progress.phase = .dayResult
        } else {
            // ゲーム継続(夜フェーズ開始)
            bufState.progress.phase = .werewolf // 人狼フェーズ
        }
        try await gameStore.updateGame(gameId: gameId, game: bufState)

    }

    // 夜の結果を判定し、昼へ移行 or ゲーム結果表示
    @MainActor func judgeNightResult() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }

        // 生存者数
        var alivedWerewolvesCount: Int = 0
        var alivedHumansCount: Int = 0
        for i in 0 ..< gamePlayers.count {
            if gamePlayers[i].alived == true {
                if gamePlayers[i].role == .Werewolf {
                    alivedWerewolvesCount += 1
                } else {
                    alivedHumansCount += 1
                }
            }
        }

        // 投票先UID初期化
        var bufPlayers = gamePlayers
        for i in 0 ..< bufPlayers.count {
            bufPlayers[i].voteUserId = ""
            try await gameStore.updateGame(gameId: gameId, player: bufPlayers[i])
        }

        // フェーズ更新
        var bufState = gameState
        if (alivedWerewolvesCount == 0) || (alivedHumansCount <= alivedWerewolvesCount) {
            // ゲーム終了
            bufState.progress.phase = .morningResult
        } else {
            // ゲーム継続(昼フェーズ開始)
            bufState.progress.phaseTimer = gamePlayers.filter({$0.alived}).count * 3   //TODO: 
            bufState.progress.phase = .discussion
        }
        try await gameStore.updateGame(gameId: gameId, game: bufState)

    }

    //TODO: 
    @MainActor func attack(uId: String, attackForId: String) async throws {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(attackForId.isEmpty) else {
            print("Error : voteForId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }
        
        // 襲撃
        var bufPlayers = gamePlayers
        guard bufPlayers.firstIndex(where: {$0.userId == attackForId}) != nil else {
            // 襲撃先UIDがこのゲームに登録されてない
            print("Error : uId(\(attackForId) is not in this game")
            throw JinlogError.unexpected
        }
        guard let idx = bufPlayers.firstIndex(where: {$0.userId == uId}) else {
            // 襲撃者がこのゲームに登録されてない
            print("Error : uId(\(uId) is not in this game")
            throw JinlogError.unexpected
        }
        bufPlayers[idx].atackUserId = attackForId
        
        // DB更新
        try await gameStore.updateGame(gameId: gameId, player: bufPlayers[idx])
    }

    //TODO: 
    @MainActor func startAnnounceAttackResult() async throws {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.unexpected
        }

        // フェーズ更新
        var bufState = gameState
        bufState.progress.phase = .attackResult
        bufState.progress.phaseTimer = 0
        try await gameStore.updateGame(gameId: gameId, game: bufState)
    }

    //TODO: 
    func getAttackedUser() -> [String] {
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            return []
        }

        // 犠牲者のUIDを抽出
        var attackedUserId: [String] = []
        for i in 0 ..< gamePlayers.count {
            // 生きている人狼の襲撃先UID
            if (gamePlayers[i].alived == true) && (gamePlayers[i].role == .Werewolf) {
                attackedUserId.append(gamePlayers[i].atackUserId)
            }
        }

        return attackedUserId
    }

}
