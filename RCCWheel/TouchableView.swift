//
//  TouchableView.swift
//  RCCWheel
//
//  Created by Михаил Митрованов on 26.08.2025.
//


import UIKit
import Network

class TouchableView: UIView {
    
    private var udp : NWConnection
    override init(frame: CGRect) {
        let udpEP = NWEndpoint.hostPort(host: NWEndpoint.Host("192.168.1.101"), port: 5678)
        
        udp = NWConnection(to: udpEP, using: NWParameters.udp)
        udp.start(queue: DispatchQueue(label: "udp_angle"))
        super.init(frame: frame)
        setupView()
 

    }
    
    required init?(coder: NSCoder) {
        let udpEP = NWEndpoint.hostPort(host: NWEndpoint.Host("192.168.1.101"), port: 5678)
        
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
    
    func makeUIView(context: Context) -> TouchableView {
        return TouchableView()
    }
    
    func updateUIView(_ uiView: TouchableView, context: Context) {
        // Обновляем при необходимости
    }
}
