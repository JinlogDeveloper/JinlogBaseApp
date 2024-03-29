//
//  CameraPreview.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/12/04.
//


import UIKit
import AVFoundation


class CameraPreview: UIView {
    
    private var label:UILabel?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session = AVCaptureSession()
    //    weak　弱参照(参照カウントとして数えられない。)
    weak var delegate: QrCodeCameraDelegate?
    
    //super: スーパークラスの実装を呼び出している。
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        self.session = session
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
}
