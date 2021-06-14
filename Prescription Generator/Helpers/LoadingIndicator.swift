//
//  LoadingIndicator.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import Foundation
import NVActivityIndicatorView

class LoadingIndicator {
    
    static let shared = LoadingIndicator();
    private var activityIndicatorView: NVActivityIndicatorView?;
    
    private init() {};
    
    func start() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first!;
            
            self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 75, height: 75), type: .ballClipRotatePulse, color: .systemBlue, padding: nil);
            self.activityIndicatorView?.center = window.center;
            window.addSubview(self.activityIndicatorView!);
            
            self.activityIndicatorView?.startAnimating();
        }
    }
    
    func stop() {
        DispatchQueue.main.async {
            self.activityIndicatorView?.removeFromSuperview();
        }
    }
}

