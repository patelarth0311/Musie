//
//  StatsView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit
import RealmSwift

struct LibraryStatView: View {

@Binding var libraryData: LibraryData
var gridItemLayout = [GridItem(.flexible())]
    
    @Binding var modal: Modal
    
    

    var body: some View {
    
   
        
        
        NavigationView {
        
              
            ScrollView(.vertical,showsIndicators: false) {
                Spacer()
                    
                VStack {
                        
                    LazyVGrid(columns: gridItemLayout, spacing: 11) {
                        
                        Group {
                            
                            
                            HStack {
                                StatView(number: libraryData.totalMinutes, title: "Minutes listened")
                                
                                
                                Spacer()
                                
                                
                                StatView(number: libraryData.playCount, title: "Play count")
                                
                            }
                            Spacer()
                            
                            
                            TopView(libraryData: $libraryData, modal: $modal)
                        }
                    }
                    }
                    .padding()
                    
                    
                    
                
            }
           
            
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            .navigationTitle("Overview")
            .tint(.white)
            .refreshable {
              
                self.libraryData.fetch { success in
                    
                }
          

            }
        
    }
}
}


struct StatView : View  {
var number: Double
var title: String


var body: some View {
  
  
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(.title,weight: .semibold))
                        
                        
                        .lineLimit(1)
                    Text("\(Int(number))")
                       
                        .font(.system(size: 50 , weight: .bold))
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                }
                Spacer()
            }
           
        }
       
    
   
}
}




