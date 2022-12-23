//
//  SecondView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/12/04.
//

import SwiftUI

struct QRCodeScannerView: View {
    
    @ObservedObject var qrcodeScannerSetting: QRCodeScannerSetting
    
    var body: some View {
        Text("QRコード読み取り")
        
        ZStack {
            // QRコード読み取り処理
            QRCodeScannerProcess()
                .found(r: self.qrcodeScannerSetting.onFoundQrCode)//引数に関数
                .interval(delay: self.qrcodeScannerSetting.scanInterval)//QRコードを読み取る時間間隔が引数
            
            VStack {
                VStack {
                    Text("Keep scanning for QR-codes")
                        .font(.subheadline)
                    
                    Text("QRコード読み取り結果 = [ " + self.qrcodeScannerSetting.qrcodeString + " ]")
                        .bold()
                        .lineLimit(5)
                        .padding()
                    
                    Button("Close") {
                        self.qrcodeScannerSetting.isShowing = false
                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }.padding()
            
        }
    }
}


struct QRcodeReadView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerView(qrcodeScannerSetting: QRCodeScannerSetting())
    }
}
