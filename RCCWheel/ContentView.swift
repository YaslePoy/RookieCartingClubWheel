//
//  ContentView.swift
//  RCCWheel
//
//  Created by Михаил Митрованов on 26.08.2025.
//

import SwiftUI
import CoreMotion
import Foundation
import Network

struct ContentView: View {
    let motion = CMMotionManager()


    mutating func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
       if self.motion.isAccelerometerAvailable {
           let udpEP = NWEndpoint.hostPort(host: NWEndpoint.Host("192.168.1.101"), port: 5678)
           
           let udp = NWConnection(to: udpEP, using: NWParameters.udp)
           udp.start(queue: DispatchQueue(label: "udp_angle"))
          self.motion.accelerometerUpdateInterval = 1.0 / 50.0  // 50 Hz
           self.motion.startAccelerometerUpdates(to: .main){
               (d, e) in
               let vec = Vector2D(x: (d?.acceleration.y)!, y: (d?.acceleration.x)!).normalized
               let angle = round(atan2(vec.x, vec.y) * 1800 / Double.pi) / 10
               let data = "angle: \(String(angle))"
               
               udp.send(content: data.data(using: .utf8), completion: .contentProcessed({e in
                   if let error = e{
                       print("Some error")
                   }
               }))
           }
       }
    }
    
    init(){
        startAccelerometers()
    }

    
    func updateAngle(){
        
    }
    
    @State private var angle: Float = 15.0;
    var body: some View {
        ZStack{
            TouchableSwiftUIView().frame(width: .infinity, height: .infinity)
            HStack {
                Button{
                } label: {
                    Label("Тормоз", systemImage: "xmark.circle")
                }
                
                Spacer()
                Text(String(angle)).fontWeight(Font.Weight.bold).font(Font.title)
                Spacer()
                Button{
                } label: {
                    Label("Газ", systemImage: "xmark.circle")
                }
            }
            .padding()
        }        
    }
}

#Preview {
    ContentView()
}
