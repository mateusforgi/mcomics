//
//  BannerErrorView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 28/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct BannerErrorView: View {
    
    @Binding var error: Error?
    private var clearErrorCallback: () -> Void
    @State var height: CGFloat = 0

    init(error: Binding<Error?>, clearErrorCallback: @escaping () -> Void) {
        self._error = error
        self.clearErrorCallback = clearErrorCallback
    }
    
    var body: some View {
        error.map { error in
            Button(action: {
                self.clearError(withDelay: false)
            }, label: {
                Text(error.localizedDescription)
                    .lineLimit(2)
                    .foregroundColor(.white)
            }).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 45, alignment: .center)
                .frame(height: height)
                .background(Color.red.opacity(0.5))
                .cornerRadius(5)
                .padding([.leading, .trailing])
                .onAppear {
                    withAnimation {
                        self.height = 45
                    }
                    self.clearError(withDelay: true)
            }
            }?.accessibility(label: Text(LocalizableStrings.accessibilityBannerErrorView))
    }
    
}

extension BannerErrorView {
    
    private func clearError(withDelay: Bool) {
        DispatchQueue.main.asyncAfter(deadline: withDelay ? (.now() + 2) : .now()) {
            withAnimation {
                self.height = 0
                self.clearErrorCallback()
            }
        }
    }
    
}
