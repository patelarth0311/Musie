//
//  MediaExpandedView.swift
//  Musie
//
//  Created by Arth Patel on 8/14/23.
//

import SwiftUI
import MusicKit
import UIKit




struct AlbumExpandedView: View {
@Binding var modal: Modal
@State private var playedCount: Double = 0.0
@State private var minutesListened: Double = 0.0
var geometry: GeometryProxy
@Binding var libraryData: LibraryData
@State private  var songs : MusicItemCollection<MusicKit.Song> = MusicItemCollection<MusicKit.Song>()

@State var sortToggled = false
@Environment(\.dismiss) private var dismiss
@State var optionChoose : SortOption = .playCount

    
var body: some View {
    

        if let album = modal.albumModal.album {
            NavigationView {
               
            ScrollView {
                VStack(spacing: 15) {
                    
                    Spacer()
                    if let artwork = album.artwork {
                        
                        ArtworkImage(artwork, width: geometry.size.width - 40)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.25), radius: 20)
                        
                           
                        
                        
                        
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2)  {
                            
                            ScrollView(.horizontal) {
                                Text(album.title)
                                    .font(.system(.title, weight: .bold))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                            }
                            .frame(width: geometry.size.width - 40, alignment: .leading)
                            .scrollIndicators(.hidden)
                            
                            
                            VStack {
                                
                                ForEach(modal.albumModal.artists) { artist in
                                   
                                        ArtistSpecView(artist: artist, modal: $modal, specBG: .material)
                                        
                                    
                                    
                                }
                                .scrollItemStyle()
                            }
                            
                        }
                        
                        Spacer()
                    }
                    
                    
                    HStack {
                        
                        
                    }
                    
                    
                    .font(.system(.subheadline,weight: .semibold))
                    
                    DateView(recentlyListenDate: album.lastPlayedDate, addedDate: album.libraryAddedDate , geometry: geometry)
                    
                    Spacer()
                        .frame(height: 0)
                    VStack(spacing: 10) {
                        
                        InsightView(title: "Play Count", geometry: geometry, number: playedCount)
                        
                        InsightView(title: "Minutes Listened", geometry: geometry, number: minutesListened)
                        
                        
                    }
                    
                    
                    if (!album.title.lowercased().contains("single") && album.isSingle == nil || album.isSingle == false) {
                        VStack(alignment: .center) {
                            ForEach(modal.albumModal.songs) { song in
                                
                                    SongSpecView(song: song, modal: $modal, specBG: .material)
                                
                            }
                            .scrollItemStyle()
                            
                            
                            
                            HStack {
                                
                                
                                Text("\(modal.albumModal.songs.count) song\(modal.albumModal.songs.count > 0 ? "s" : "")")
                                
                                
                            }
                            
                            
                            .font(.system(.subheadline,weight: .semibold))
                        }
                        .padding(.bottom,20)
                    }
                    
                    
                    
                    
                    
                    
                    
                }
                .padding([.leading,.trailing])
                .padding(.top, 95)
            }
            .scrollIndicators(.hidden)
            .background(Color(album.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).brightness(0.04))
            .getContrastText(backgroundColor: Color(album.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
            .onChange(of: modal.albumModal.loaded, { _, _ in
                
           
                
        
                    
                    
                          withAnimation(.easeIn) {
                              
                              playedCount = modal.albumModal.getPlayCount()
                              minutesListened = modal.albumModal.getMinutesPlayed()
                          }
              
               
              
                
                
            })
            .task(priority: .high, {
                withAnimation(.easeIn) {
                    playedCount = modal.albumModal.getPlayCount()
                    minutesListened = modal.albumModal.getMinutesPlayed()
                }
            })
            
            
            
          
          
            .frame(minWidth: geometry.size.width,maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            
            .blurredNavBar(height: 130)
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation( .smooth){
                            modal.albumModal = AlbumModalData()
                        }
                        
                        
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward")
                            .font(.system(size: 20,weight: .medium))
                            .getContrastText(backgroundColor: Color(album.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        SortOptionButton(contentType: .songs,  optionChoose: $optionChoose)
                     
                            .onChange(of: optionChoose) { oldValue, newValue in
                                print(newValue)
                                modal.albumModal.sort(sortOption: newValue)
                                withAnimation {
                                    sortToggled.toggle()
                                }
                               
                            }
                    } label: {
                        
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20,weight: .medium))
                            .symbolEffect(.bounce.byLayer, value: sortToggled)
                            .getContrastText(backgroundColor: Color(album.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                    }
                    
                }
            }
        }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .ignoresSafeArea(.all)
        
            
            
            
            
            
            
            
            
    }
}


}











