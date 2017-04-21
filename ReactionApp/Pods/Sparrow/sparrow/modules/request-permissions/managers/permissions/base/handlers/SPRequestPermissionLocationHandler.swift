// The MIT License (MIT)
// Copyright © 2017 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import MapKit

class SPRequestPermissionLocationHandler: NSObject, CLLocationManagerDelegate {
    
    static var shared: SPRequestPermissionLocationHandler?
    
    lazy var locationManager: CLLocationManager =  {
        return CLLocationManager()
    }()
    
    var complectionHandler: SPRequestPermissionAuthorizationHandlerCompletionBlock?
    
    override init() {
        super.init()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        
        if let complectionHandler = complectionHandler {
            complectionHandler(isAuthorized())
        }
    }
    
    func requestPermission(_ complectionHandler: @escaping SPRequestPermissionAuthorizationHandlerCompletionBlock) {
        self.complectionHandler = complectionHandler
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization();
        } else {
            complectionHandler(isAuthorized())
        }
    }
    
    func isAuthorized() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways {
            return true
        }
        if status == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    deinit {
        locationManager.delegate = nil
    }
}

class SPRequestPermissionLocationWithBackgroundHandler: SPRequestPermissionLocationHandler {
    
    override func requestPermission(_ complectionHandler: @escaping SPRequestPermissionLocationHandler.SPRequestPermissionAuthorizationHandlerCompletionBlock) {
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        super.requestPermission(complectionHandler)
    }
}

extension SPRequestPermissionLocationHandler {
    
    typealias SPRequestPermissionAuthorizationHandlerCompletionBlock = (Bool) -> Void
}