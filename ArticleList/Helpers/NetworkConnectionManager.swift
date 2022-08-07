//
//  NetworkConnectionManager.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 07.08.22.
//

import Foundation
import Network

@objcMembers class NetworkConnectionManager : NSObject {
    
    static let shared = NetworkConnectionManager()
    
    private var didStartMonitoringHandler: (() -> Void)?
    private var didStopMonitoringHandler: (() -> Void)?
    private var netStatusChangeHandler: (() -> Void)?
    
    private var monitor: NWPathMonitor?
    private var isMonitoring = false
    
    public var isReachable: Bool {
        
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    public var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    public var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    public var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    
    //MARK: - Initialize Methods
    override init() {}
    
    deinit {
        stopMonitoring()
    }
    
    
    //MARK: -  Private Methods
    private func provideConnectionState() {
        
        if self.isReachable {
            self.didReceiveInternetConnection()
        }
        else {
            self.didLostInternetConnection()
        }
    }
    
    private func didLostInternetConnection() {
        
        NotificationCenter.default.post(name:NSNotification.Name(Constants.kNRMDidLostInternetConnectionNotification),
                                        object:nil)
    }
    
    private func didReceiveInternetConnection() {
        
        NotificationCenter.default.post(name:NSNotification.Name(Constants.kNRMDidReceiveInternetConnectionNotification),
                                        object:nil)
    }
    
    
    //MARK: -  Public Methods
    @objc public func startMonitoring() {
        
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { [weak self]  _ in
            
            guard let self = self else { return }
            
            self.provideConnectionState()
            self.netStatusChangeHandler?()
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    public func stopMonitoring() {
        
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
