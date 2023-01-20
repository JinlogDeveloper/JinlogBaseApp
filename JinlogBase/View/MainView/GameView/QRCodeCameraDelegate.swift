//
//  QrCodeCameraDelegate.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/12/04.
//

import AVFoundation

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var onResult: (String) -> Void = { _  in }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }
    
    
    func foundBarcode(_ stringValue: String) {
        //インターバル毎に処理するのを辞めたら、foundBarcodeが一回しかはしらなくなったかも？原因不明
        self.onResult(stringValue)
        
    }
}
