//
//  SongExpandedView.swift
//  Musie
//
//  Created by Arth Patel on 8/22/23.
//

import SwiftUI
import MusicKit

import Charts

struct SongExpandedView: View {
@Binding var modal: Modal
var geometry: GeometryProxy
@Environment(\.dismiss) private var dismiss
@State private var playedCount: Double = 0
@State private var minutesListened: Double = 0


@Binding var libraryData: LibraryData


var body: some View {
    
    
    if let song = modal.songModal.song {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Spacer()
                    
                    if let artwork = song.artwork {
                        
                        ArtworkImage(artwork, width: geometry.size.width - 40)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.25), radius: 20)
                           
                        
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2)  {
                            
                            ScrollView(.horizontal) {
                                Text(song.title)
                                    .font(.system(.title, weight: .bold))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                            }
                            .frame(width: geometry.size.width - 40, alignment: .leading)
                            .scrollIndicators(.hidden)
                            
                            VStack {
                                
                                ForEach(modal.songModal.artistsArray) { artist in
                                  
                                        ArtistSpecView(artist: artist, modal: $modal, specBG: .material)
                                        
                                        
                                    
                                    
                                }
                                .scrollItemStyle()
                                
                            }
                            
                        }
                        
                        Spacer()
                    }
                    
                    
                    HStack {
                        if song.genreNames.count > 0 {
                            Text("\(song.genreNames[0])")
                        }
                        if let releaseDate = song.releaseDate {
                            Text(releaseDate.formatted(date: .numeric, time: .omitted))
                        }
                        
                        
                    }
                    
                    
                    .font(.system(.subheadline,weight: .semibold))
                    DateView(recentlyListenDate: song.lastPlayedDate, addedDate: song.libraryAddedDate , geometry: geometry)
                    
                 
                    
                    VStack(spacing: 10) {
                        
                        InsightView(title: "Play Count", geometry: geometry, number: playedCount)
                        
                        InsightView(title: "Minutes Listened", geometry: geometry, number: minutesListened)
                        
                        VStack(alignment: .leading) {
                            Text("Plays over Time")
                                .font(.system(.title3,weight: .semibold))
                                .foregroundStyle(.secondary)
                            Chart( libraryData.realm.objects(SongListened.self).filter(NSPredicate(format: "musicId == %@", song.id.rawValue )).first!.playsOverTime) { item in
                                LineMark(x: .value("Time", item.date, unit: .day), y: .value("playCount", item.playCount))
                                    .symbol(.circle)
                                    .foregroundStyle(Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                                
                                    .lineStyle(StrokeStyle(lineWidth: 2))
                                
                                AreaMark(
                                    x: .value("Time", item.date, unit: .day),
                                    yStart: .value("playStart", 0),
                                    // get the max close value or adjust to your use case
                                    
                                    yEnd: .value("playEnd", item.playCount)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient (
                                            colors: [
                                                Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.5),
                                                Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.2),
                                                Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.05),
                                            ]
                                        ),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0...song.playCount! + 100)
                            
                            
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                           
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Minutes Listened over Time")
                                .font(.system(.title3,weight: .semibold))
                                .foregroundStyle(.secondary)
                            Chart( libraryData.realm.objects(SongListened.self).filter(NSPredicate(format: "musicId == %@", song.id.rawValue )).first!.playsOverTime) { item in
                                LineMark(x: .value("Time", item.date, unit: .day), y: .value("playCount", item.minutesListened))
                                    .symbol(.circle)
                                    .foregroundStyle(Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                                
                                    .lineStyle(StrokeStyle(lineWidth: 2))
                                
                                AreaMark(
                                    x: .value("Time", item.date, unit: .day),
                                    yStart: .value("playStart", 0),
                                    // get the max close value or adjust to your use case
                                    
                                    yEnd: .value("playEnd", item.minutesListened)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient (
                                            colors: [
                                                Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.5),
                                                Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.2),
                                                Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.05),
                                            ]
                                        ),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0...Int(  Double(song.playCount ?? 0) * ((song.duration ?? TimeInterval())/60.0)) + 100)
                            
                            
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                           
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    Spacer()
                }
                
                .padding([.leading,.trailing])
                .padding(.top, 95)
                
            }
            .blurredNavBar(height: 130)
            
            .scrollIndicators(.hidden)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation( .smooth){
                            modal.songModal = SongModalData()
                        }
                           
                            
                        
                        
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward")
                            .font(.system(size: 20,weight: .medium))
                            .getContrastText(backgroundColor: Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                    }
                }
                
            }
          
           
            .background(Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).brightness(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .getContrastText(backgroundColor: Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
          
          
            
           
            .frame(minWidth: geometry.size.width,maxWidth: .infinity, maxHeight: .infinity)
          
            .ignoresSafeArea(.all)
          
            .navigationBarBackButtonHidden(true)
           
            .onChange(of: modal.songModal.loaded, { _, _ in
                
                
                    withAnimation(.easeIn) {
                        playedCount = modal.songModal.getPlayCount()
                        minutesListened =  modal.songModal.getMinutesPlayed()
                       
                    }
                   
               
            })
           
            .task(priority: .high, {
              
                withAnimation(.easeIn) {
                   
                    playedCount = modal.songModal.getPlayCount()
                    minutesListened =  modal.songModal.getMinutesPlayed()
                  
                }
            })
            
            
            
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .ignoresSafeArea(.all)
        
    }
}

}


