//
//  SplashScreenView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 03/05/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct SplashScreenView: View {
    
    // MARK: Variables
    static var shouldAnimate = true
    private let zoomFactor: CGFloat = 1.4
    
    // MARK: State
    @State private var scale: CGFloat = 1
    @State private var textAlpha = 0.0
    @State private var textScale: CGFloat = 1
    
    // MARK: Body
    var body: some View {
        ZStack(alignment: .center) {
            Image("Diamond")
                .resizable(resizingMode: .tile)
                .opacity(textAlpha)
                .scaleEffect(textScale)
            
            Text(getAppName())
                .font(.largeTitle)
                .opacity(textAlpha)
                .scaleEffect(textScale)
                .foregroundColor(Color.init(UIColor.systemTeal))
            
            Image("Diamond")
                .rotationEffect(.degrees(-90))
                .aspectRatio(1, contentMode: .fit)
                .padding(20)
                .onAppear() {
                    self.handleAnimations()
            }
            .scaleEffect(scale * zoomFactor)
            .frame(width: 45, height: 45,
                   alignment: .center)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}


// MARK: Private
extension SplashScreenView {
    
    private var animationDuration: Double { return 1.0 }
    private var animationDelay: Double { return  0.2 }
    private var exitAnimationDuration: Double { return 0.3 }
    private var finalAnimationDuration: Double { return 0.4 }
    
    private func handleAnimations() {
        runAnimationPart1()
        runAnimationPart2()
        if SplashScreenView.shouldAnimate {
            restartAnimation()
        }
    }
    
    private func runAnimationPart1() {
        withAnimation(.easeIn(duration: animationDuration)) {
            scale = 5
        }
        
        withAnimation(Animation.easeIn(duration: animationDuration).delay(0.5)) {
            textAlpha = 1.0
        }
        
        let deadline: DispatchTime = .now() + animationDuration + animationDelay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            withAnimation(.easeOut(duration: self.exitAnimationDuration)) {
                self.scale = 0
            }
            
            withAnimation(Animation.spring()) {
                self.textScale = self.zoomFactor
            }
        }
    }
    
    private func runAnimationPart2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2*animationDuration) {
            withAnimation(.easeIn(duration: self.finalAnimationDuration)) {
                self.textAlpha = 0
            }
        }
    }
    
    private func restartAnimation() {
        let deadline: DispatchTime = .now() + 2*animationDuration + finalAnimationDuration
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.textScale = 1
            self.handleAnimations()
        }
    }
    
    private func getAppName() -> String {
        guard let appName = InfoPlistEnvironment.getInfoPlistVariable(plistKey: .cfBundleDisplayName) else {
            return "MComics"
        }
        return appName
    }
    
}
