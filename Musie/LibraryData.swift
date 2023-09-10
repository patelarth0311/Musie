//
//  Song.swift
//  Musie
//
//  Created by Arth Patel on 8/13/23.
//

import Foundation
import MusicKit
import SwiftUI
import RealmSwift



@Observable class AMLibraryData {
    var songs : MusicItemCollection<MusicKit.Song> = MusicItemCollection<MusicKit.Song>()
    var artists : MusicItemCollection<MusicKit.Artist> = MusicItemCollection<MusicKit.Artist>()
    var albums : MusicItemCollection<MusicKit.Album> = MusicItemCollection<MusicKit.Album>()
    
    init() {
        
    }
}

@Observable class LibraryData : AMLibraryData  {
    
    let realm = try! Realm()
    var loaded = false
    var totalMinutes : Double = 0.0
    var playCount : Double = 0.0
   
    var songAddedData: ([Date : Int], Int) = ([:],0)
    var artistAddedData: ([Date : Int], Int) = ([:],0)
    var albumAddedData: ([Date : Int], Int) = ([:],0)
    
    override
    init() {
        super.init()
        
        self.fetch { success in
            if success {
                
                        self.loaded = true
                    
                
            }
        }
        
    }
    
    private func requestAM() async -> MusicAuthorization.Status {
        let status = await MusicAuthorization.request()
        return status
    }
    
    
    
    func sort(contentType: ContentType, optionChoose: SortOption) {
     
            switch contentType {
            case .songs:
                sortSongs(sortOption: optionChoose) { data in
                    self.songs = data
                }
            case .artists:
                sortArtists(sortOption: optionChoose) { data in
                    self.artists = data
                }
            case .albums:
                sortAlbums(sortOption: optionChoose) { data in
                    self.albums = data
                }
            }
            
        
    }
    
    
     func getPlaysAndMinutes() -> (Double,Double) {
        
        var totalMinutes : Double = 0.0
        var playCount : Double = 0.0
         
        self.songs.forEach { song in
            if let plays = song.playCount, let interval = song.duration {
             totalMinutes = totalMinutes + (Double(plays) * ((interval)/60))
             playCount = playCount + Double(plays)
               
                DispatchQueue.main.async {
                    self.realm.writeAsync {
                      
                               let entry = self.realm.objects(SongListened.self).first { item in
                                            item.musicId == song.id.rawValue
                                        }
                                        
                                        if let existingEntry = entry {
                                            
                                            
                                            if let date = song.lastPlayedDate, let playcount = song.playCount, let duration = song.duration {
                                                let entry = existingEntry.playsOverTime.first { item in
                                                    item.date == Date.now.startOfDay
                                                    
                                                }
                                               
                                                if let existingDate = entry {
                                                    existingDate.playCount = playcount
                                                    existingDate.minutesListened = Int(  Double(song.playCount ?? 0) * (duration/60.0))
                                                   
                                                } else {
                                                    existingEntry.playsOverTime.append(ListeningData(date: Date(), playCount: song.playCount ?? 0, minutesListened: Int(  Double(song.playCount ?? 0) * (duration/60.0))))
                                                }
                                               
                                            }
                                            
                                        } else {
                                            if let playcount = song.playCount, let duration = song.duration {
                                                let songListened = SongListened(musicId: song.id.rawValue, playsOverTime: List<ListeningData>())
                                                
                                                
                                                songListened.playsOverTime.append(ListeningData(date: song.lastPlayedDate ?? Date(), playCount: song.playCount ?? 0, minutesListened:  Int(  Double(song.playCount ?? 0) * (duration/60.0))))
                                                
                                                if let date = song.lastPlayedDate {
                                                    if date.startOfDay != Date.now.startOfDay {
                                                        songListened.playsOverTime.append(ListeningData(date: Date(), playCount: song.playCount ?? 0, minutesListened: Int(  Double(song.playCount ?? 0) * (duration/60.0))))
                                                    }
                                                }
                                                
                                            
                                                self.realm.add(songListened )
                                            }
                                        }
                                        
                            
                   }
                   
                }
              
            }
        }
       
         return (totalMinutes, playCount)
    }
    
    
    
    func fetch(_ completion: @escaping (_ success: Bool) -> Void) {
        
        
        Task {
            var currentDay = Calendar.current.startOfDay(for: .now)
            let status = await self.requestAM()
            
            switch status {
            case .authorized:
                var songMusicRequest = MusicLibraryRequest<MusicKit.Song>()
                songMusicRequest.sort(by: \.title, ascending: true)
             
                var artistMusicRequest = MusicLibraryRequest<MusicKit.Artist>()
                artistMusicRequest.sort(by: \.name, ascending: true)
                
                var albumMusicRequest = MusicLibraryRequest<MusicKit.Album>()
                albumMusicRequest.sort(by: \.title, ascending: true)
                
                do {
                    let songResult = try await songMusicRequest.response()
                    
                   
     
                    self.songs = songResult.items
                  
                    self.songAddedData = self.songs.filterByTime(date: currentDay, dateComponent: .day)
                    
                    let artistResult = try await artistMusicRequest.response()
                    self.artists = artistResult.items
                    self.artistAddedData = self.artists.filterByTime(date: currentDay, dateComponent: .day)
                    
                    let albumResult = try await albumMusicRequest.response()
                    self.albums = albumResult.items
                    self.albumAddedData = self.albums.filterByTime(date: currentDay, dateComponent: .day)
                    (self.totalMinutes, self.playCount) =  self.getPlaysAndMinutes()
                    
                   completion(true)
                    
                } catch {
                    print(error)
                    completion(false)
                }
            default:
                print("a")
            }
        }
    }






}


