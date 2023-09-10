//
//  SongStatView.swift
//  Musie
//
//  Created by Arth Patel on 8/26/23.
//

import Foundation
import SwiftUI
import MusicKit

struct SongStatView : View {
    var number: Double
    var title: String
    var songs: MusicItemCollection<MusicKit.Song>
    @State var song: Song
    @State var selected : Song
    @Binding var libraryData: LibraryData
  
    @Namespace var namespace
  
    @Binding var modal: Modal
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            
    
                
                
                HStack(alignment: .bottom) {
                    
                    
                    
                    
                    if let artwork = selected.artwork {
                        
                        if (song == selected) {
                      
                            VStack(alignment: .leading) {
                                ArtworkImage(artwork, width: (Double(Int(UIScreen.main.bounds.width - 115))))
                                
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.25), radius: 20)
                                    .onTapGesture {
                                                   
                                  
                                            
                                    withAnimation( .smooth){
                                               
                                                modal.artistModal =     ArtistModalData()
                                                modal.albumModal =   AlbumModalData()
                                                modal.songModal = SongModalData(song: song)
                                             
                                       
                                                
                                            }
                                        
                                               }
                                   
                                    .overlay (alignment: .bottomTrailing) {
                                        
                                        Text("")
                                            .font(.system(size: 50 , weight: .bold))
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .offset(x: -10)
                                        
                                    }
                                   
                                
                                Spacer()
                                
                            }
                        
                           
                            .zIndex(10)
                           
                            
                        }
                        
                    }
                    
                    
                    VStack(spacing: 5) {
                        ForEach(songs.prefix(5)) { song  in
                            
                            if let artwork = song.artwork {
                                
                                if (selected != song) {
                                    Button {
                                        withAnimation(.smooth) {
                                            self.song = song
                                            self.selected = song
                                            
                                            modal.artistModal =     ArtistModalData()
                                            modal.albumModal =   AlbumModalData()
                                            modal.songModal = SongModalData(song: song)
                                        }
                                    } label : {
                                        ArtworkImage(artwork, width: (Double(Int(UIScreen.main.bounds.width - 130)) / 4))
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                        
                                        
                                            .shadow(color: .black.opacity(0.3), radius: 7)
                                           
                                        
                                        
                                        
                                            .overlay(alignment: .bottomTrailing) {
                                                
                                                
                                                
                                                Text("")
                                                    .font(.system(size: 20 , weight: .bold))
                                                    .minimumScaleFactor(0.05)
                                                    .lineLimit(1)
                                                    .offset(x: -10)
                                            }
                                        
                                        
                                    }
                                    .matchedGeometryEffect(id: song.id.rawValue + title, in: namespace)
                                    
                                    
                                
                                
                            }
                        }
                      
                    }
                    
                        Spacer()
                }
                    
                  
                 
                
                
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(selected.title)
                        .font(.system(size: 35 , weight: .bold))
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                    
                    Text(selected.artistName)
                        .font(.system(size: 25 , weight: .regular))
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                }
                
            }
           
          
        }
        
        
            .onChange(of: libraryData.songs, { oldValue, newValue in
                self.song = songs[0]
                self.selected = songs[0]
            })
      
        
    }
        
}
