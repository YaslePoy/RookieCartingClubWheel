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
    @State var udp: NWConnection
    @State private var ip : String = "192.168.1.101"
    @State private var angle: Float = 15.0;


    func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
        udp.start(queue: DispatchQueue(label: "udp_input"))
       if self.motion.isAccelerometerAvailable {
           let conn = udp
           self.motion.accelerometerUpdateInterval = 1.0 / 50.0  // 50 Hz
           self.motion.startAccelerometerUpdates(to: .main) {
               (d, e) in
               let vec = Vector2D(x: (d?.acceleration.y)!, y: (d?.acceleration.x)!).normalized
               let angle = round(atan2(vec.x, vec.y) * 1800 / Double.pi) / 10
               let data = "angle: \(String(angle))"
               
               conn.send(content: data.data(using: .utf8), completion: .contentProcessed({e in
                   if let error = e{
                       print("Some error")
                   }
               }))
           }
       }
    }
    
    init(){
        udp = NWConnection(host: .ipv4(.loopback), port: .any, using: .udp)
    }

    
    func updateAngle(){
        
    }
    
    var body: some View {
        ZStack{
            TouchableSwiftUIView(udp: $udp).frame(width: .infinity, height: .infinity)
            HStack {
                Button{
                } label: {
                    Label("Тормоз", systemImage: "xmark.circle")
                }
                
                Spacer()
                VStack{
                    TextField("IP-адрес",text: $ip).multilineTextAlignment(.center).padding().background()
                    
                    Button(action: {
                        motion.stopAccelerometerUpdates()
                
                        let ep = NWEndpoint.hostPort(host: NWEndpoint.Host(ip), port: 5678)
                        udp = NWConnection(to: ep, using: .udp)
                        startAccelerometers()
                        
                    }){
                        Label("Подключение", systemImage: "network")
                    }
                }
                
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
