//
//  TopView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit

struct TopView: View {

    @State var toggle = false
    @Binding var libraryData: LibraryData
    @Binding var modal: Modal
  
    @Namespace var namespace
    
    


    
    var body: some View {
      
        VStack(spacing: 20) {
                
                
                   
                    TopStatView(title: "Songs",libraryData: $libraryData, modal: $modal, contentType: .songs)
                         
                   
                            
                    TopStatView(title: "Albums", libraryData: $libraryData, modal: $modal, contentType: .albums)
                           
                 
                    TopStatView(title: "Artists",  libraryData: $libraryData, modal: $modal, contentType: .artists)
               
            }
           
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            
           
          
          
        
        
    
    }
}



struct TopStatView: View {
    var title: String
   
    @State var toggle = false
    @Binding var libraryData: LibraryData
    @Binding var modal : Modal
    var contentType : ContentType
 
    @State var optionChoose : SortOption  = .title
    @State var sortToggled : Bool = false
  
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom)  {
                
                switch contentType {
                case .songs:
                    StatView(number: Double(libraryData.songs.count), title: title)
                case .artists:
                    StatView(number: Double(libraryData.artists.count), title: title)
                case .albums:
                    StatView(number: Double(libraryData.albums.count), title: title)
                }
               
                Spacer()
                
                VStack(alignment: .trailing) {
                    Menu {
                        SortOptionButton(contentType: contentType, optionChoose: $optionChoose)
                            .onChange(of: optionChoose) { oldValue, newValue in
                                libraryData.sort(contentType: contentType, optionChoose: optionChoose)
                                withAnimation {
                                    sortToggled.toggle()
                                    
                                }
                            }
                    } label: {
                        Text( optionChoose == .title && contentType == .artists ? "Name" :  optionChoose.rawValue)
                            .font(.system(size: 20,weight: .medium))
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20,weight: .medium))
                            .symbolEffect(.bounce.byLayer, value: sortToggled)
                        
                    }
                    .onTapGesture {
                        withAnimation {
                            sortToggled.toggle()
                        }
                    }
                    Spacer()
                    NavigationLink {
                        DetailedStatView(libraryData: $libraryData, modal: $modal, contentType: contentType)
                           
                    } label: {
                        
                        Text("See more")
                            .font(.system(size: 20,weight: .medium))
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 20,weight: .medium))
                          
                    }
                }
                .foregroundStyle(.pink)
            }
                        
                            
                                
                                switch contentType {
                                case .songs:
                                    
                                    
                                    SongStatView(number: Double(libraryData.songs.count), title: "Songs", songs: libraryData.songs, song: libraryData.songs[0], selected: libraryData.songs[0], libraryData: $libraryData, modal: $modal)
                                       
                                  
                               
                                  
                                    
                                case .artists:
                                    
                                    ArtistStatView(number: Double(libraryData.artists.count),title: "Artist", artists: libraryData.artists,artist: libraryData.artists[0],
                                             selected: libraryData.artists[0],libraryData: $libraryData, modal: $modal)
                                    
                                   
                                  
                                case .albums:
                                    AlbumStatView (number: Double(libraryData.albums.count),title: "Albums", albums: libraryData.albums,album: libraryData.albums[0],
                                             selected: libraryData.albums[0],libraryData: $libraryData, modal: $modal)
                                    
                                }
                
                        
                            
          
       
            
        }
       
      
       
    
        
        
    }
}




struct SortOptionButton: View {
    var contentType : ContentType

    @Binding var optionChoose : SortOption
    var body: some View {
            ForEach(contentType.filterOption,id: \.self) { option in
                Button(action: {
                 
                        optionChoose = option
                 
                }, label: {
                    Text(option.rawValue)
                })
            }
        
    }
}



