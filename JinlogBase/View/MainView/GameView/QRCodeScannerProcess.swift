//
//  QrCodeScannerView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/12/04.
//

import SwiftUI
import AVFoundation


struct QRCodeScannerProcess: UIViewRepresentable {
    
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    //typealias でCameraPreviewという型名を、UIViewTypeという別名をつけている。
    typealias UIViewType = CameraPreview
    
    private let session = AVCaptureSession()
    private let delegate = QrCodeCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    //表示するViewの初期状態のインスタンスを生成するメソッド
    func makeUIView(context: UIViewRepresentableContext<QRCodeScannerProcess>) -> QRCodeScannerProcess.UIViewType {
        let cameraView = CameraPreview(session: session)
        
        //カメラの認証ステータスの確認
        checkCameraAuthorizationStatus(cameraView)
        
        return cameraView
    }
    
    private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) {
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            setupCamera(uiView)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera(uiView)
                    }
                }
            }
        }
    }
    
    func setupCamera(_ uiView: CameraPreview) {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if let input = try? AVCaptureDeviceInput(device: backCamera) {
                session.sessionPreset = .photo //画質の設定
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    
                    metadataOutput.metadataObjectTypes = supportedBarcodeTypes
                    metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                }
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                
                uiView.backgroundColor = UIColor.gray
                previewLayer.videoGravity = .resizeAspectFill
                uiView.layer.addSublayer(previewLayer)
                uiView.previewLayer = previewLayer
                
                session.startRunning()
            }
        }
        
    }
    
    //表示するビューの状態が更新されるたびに呼び出され更新を反映させる
    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<QRCodeScannerProcess>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    //@escaping クロージャをエスケープ（エスケープクロージャ）
    func found(r: @escaping (String) -> Void) -> QRCodeScannerProcess {
        delegate.onResult = r
        
        return self
    }
    
    //UIViewを解体する
    static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
        uiView.session.stopRunning()
    }
    
}

struct QrCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerProcess()
    }
}
