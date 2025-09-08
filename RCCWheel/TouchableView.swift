//
//  TouchableView.swift
//  RCCWheel
//
//  Created by Михаил Митрованов on 26.08.2025.
//


import UIKit
import Network

class TouchableView: UIView {
    
    public var udp : NWConnection
    
    override init(frame: CGRect) {
        udp = NWConnection.init(to: .hostPort(host: .ipv4(.any), port: 0), using: .udp)

        super.init(frame: frame)
        setupView()
    }
    
    init(connection: NWConnection){
        self.udp = connection;

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))


        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        let udpEP = NWEndpoint.hostPort(host: NWEndpoint.Host("172.20.10.6"), port: 5678)
        
        udp = NWConnection(to: udpEP, using: NWParameters.udp)
        udp.start(queue: DispatchQueue(label: "udp_angle"))
        
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        isMultipleTouchEnabled = true  // Важно для двух пальцев!
         backgroundColor = .systemBackground
    }
    
    // MARK: - Обработка касаний
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("🔸 touchesBegan")
        for touch in touches {
            let location = touch.location(in: self)
            sendInput(location: normalized(point: location))

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("🔹 touchesMoved")

        for touch in touches {
            let location = touch.location(in: self)
            sendInput(location: normalized(point: location))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("🔸 touchesEnded")
        for touch in touches {
            var location = normalized(point:  touch.location(in: self))
            location.y = -1
            sendInput(location: location)
        }
    }
    
    func normalized(point: CGPoint) -> CGPoint{
        let width = self.bounds.width
        let height = self.bounds.height
        
        var location = CGPoint(x: point.x, y: point.y)
        location.x = (location.x / height - 1) * 100;
        location.y = 1 - (location.y / width) * 2
        location.y *= 100
        return location
    }
    
    func sendInput(location: CGPoint){
        var header = ""
        if location.x > 0 {
            header = "gas: "
        }else{
            header = "break: "
        }
    
        var value = 0.0;
        
        if location.y > 90 {
            value = 100
        }else if location.y > 10{
            value = location.y - 10 / 0.8
        }
        
        var result = Int(value)
        header += String(result)
        print("sending \(header)")
        udp.send(content: header.data(using: .utf8), completion: .contentProcessed({e in
        }))
    }
}

import SwiftUI

struct TouchableSwiftUIView: UIViewRepresentable {
    private let connection: NWConnection;
    
    init(udp: Binding<NWConnection>){
        connection = udp.wrappedValue
    }
    
    func makeUIView(context: Context) -> TouchableView {
        var view = TouchableView()
        view.udp = self.connection
        return view
    }
    
    func updateUIView(_ uiView: TouchableView, context: Context) {
        // Обновляем при необходимости
        print("updating")
        uiView.udp = connection
    }
}
