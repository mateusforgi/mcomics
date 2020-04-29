//
//  ErrorBannerView.swift
//  MComics
//
//  Created by Mateus Forgiarini da Silva  on 28/04/20.
//  Copyright © 2020 Mateus Forgiarini da Silva. All rights reserved.
//

import SwiftUI

struct ErrorBannerView: View {
    
    @Binding var error: Error?
    private var clearErrorCallback: () -> Void
    
    init(error: Binding<Error?>, clearErrorCallback: @escaping () -> Void) {
        self._error = error
        self.clearErrorCallback = clearErrorCallback
    }
    
    var body: some View {
        getErrorView()
    }
}

extension ErrorBannerView {
    
    private func getErrorView() -> some View {
        guard let error = error else {
            return AnyView(EmptyView())
        }
        clearErrorWithDelay()
        return AnyView(Button(action: {
            withAnimation {
                self.error = nil
            }
        }, label: {
            Text(error.localizedDescription)
                .lineLimit(2)
                .foregroundColor(.white)
        }).transition(.asymmetric(insertion: .scale, removal: .fade))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 45, alignment: .center)
            .background(Color.red.opacity(0.5))
            .cornerRadius(5)
            .padding([.leading, .trailing]))
        
    }
    
    private func clearErrorWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.clearErrorCallback()
        }
    }
    
}
