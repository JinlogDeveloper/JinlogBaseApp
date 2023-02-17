//
//  ScannerViewModel.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/12/04.
//

import Foundation

class QRCodeScannerSetting: ObservableObject {
    
    
    @Published var qrcodeString: String = "QRコード"
    @Published var isShowing: Bool = false
    
    /// QRコード読み取り時に実行される。
    /// 引数のアンダースコア　引数ラベルの省略
    func onFoundQrCode(_ qrcode: String) {
        // QRcodeを見つけた時の処理は全てここに記載する。
        // 今回は、QRCodeScannerViewを閉じる命令もここでした方が分かりやすい。
        //QRcodeを見つけたら、文字列がゲーム参加の文字列か確認
        //正しければ、QRcode読み取り画面を閉じてゲームに参加させる。
        //正しいかどうかの判断基準 文字数が20文字
        //正しくなければ、QRcodeを読み取り続ける。(間違っている旨のテキストをQRcode読み取り画面に表示する。)
        
        
        if qrcode.count == 20 {
            
            self.qrcodeString = qrcode
            isShowing = false
            
        } else {
            self.qrcodeString = "QRコードが正しくありません。"
            print("文字数:\(qrcode.count)")
            print(qrcode)
            isShowing = false
            
        }
        
    }
}
