//
//  ContentView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit


struct ContentView: View {

@Binding var libraryData: LibraryData
@Binding var modal: Modal

 @State var selection : Selection = .overview

var body: some View {

    
        
        TabView  {
            
            
            Group {
                
                
                
                
                LibraryStatView(libraryData: $libraryData, modal: $modal)
                    .tabItem {
                        
                        Label("Overview", systemImage: "music.note")
                        
                        
                    }
                    
                
                
                InsightsView(libraryData: $libraryData)
                    .tabItem {
                        Label("Insights", systemImage: "chart.bar")
                        
                        
                    }
            }
           
            
        }
      
        .tint(.pink)
       
   
        
       
      
       
       

    
       
}

}

enum Selection {
    case overview
    case top
}

struct BottomBar : View {
    
    @Binding var selection : Selection
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Button {
                withAnimation(.spring) {
                    selection = .overview
                }
                
            } label: {
                Image(systemName: "music.note")
                    .font(.system(size: 20))
                    .padding()
                    .foregroundStyle(selection == .overview ? .pink : .secondary)
                
                    .scaleEffect(selection == .overview ? 1.2 : 1)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring) {
                    selection = .top
                }
                
            } label: {
                
                Image(systemName: "music.quarternote.3")
                    .font(.system(size: 20))
                    .padding()
                    .foregroundStyle(selection == .top ? .pink : .secondary)
                    .scaleEffect(selection == .top ? 1.2 : 1)
                
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.ultraThickMaterial)
        .cornerRadius(50)
    
}
    
}
