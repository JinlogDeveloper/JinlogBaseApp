//
//  QrCodeCameraDelegate.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/12/04.
//

import AVFoundation

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var lastTime = Date(timeIntervalSince1970: 0)
    
    var onResult: (String) -> Void = { _  in }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }
    
    
    func foundBarcode(_ stringValue: String) {
        
        self.onResult(stringValue)
        
    }
}
