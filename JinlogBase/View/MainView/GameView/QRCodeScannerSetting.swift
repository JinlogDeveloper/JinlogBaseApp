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
        //正しくなければ、QRcodeを読み取り続ける。(間違っている旨のテキストをQRcode読み取り画面に表示する。)
        
        
        
        
        self.qrcodeString = qrcode
        print(qrcode)
        
        // ★（参考：変更しなくてOK！）
        // ★呼び元がこのViewを非表示にすべきという考え方もあります！
        // ★「誰が主導権を持っているか」という考え方です！
        isShowing = false
    }
}
