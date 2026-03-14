//
//  GlassTabBar.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import SwiftUI

struct GlassTabBar: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            tabItem(icon: "house.fill", index: 0)
            Spacer()
            tabItem(icon: "newspaper.fill", index: 1)
            Spacer()
            tabItem(icon: "plus", index: 2)
            Spacer()
            tabItem(icon: "book.closed.fill", index: 3)
            Spacer()
            tabItem(icon: "person.fill", index: 4)
            
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 20)
        .padding(.bottom, 4)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
    
    func tabItem(icon: String, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            Image(systemName: icon)
                .font(.system(size: index == 2 ? 28 : 20))
                .foregroundStyle(.black)
                .padding(18)
                .background(
                    Circle()
                        .fill(selectedTab == index ? AppColors.greenAccent : Color.clear)
                )
        }
    }
}

#Preview {
    ContentView()
}
