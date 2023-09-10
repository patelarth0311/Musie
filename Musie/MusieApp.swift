//
//  MusieApp.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import RealmSwift
import BackgroundTasks


@main
struct MusieApp: SwiftUI.App {
@State private var libraryData = LibraryData()
@State private var modal = Modal()
@Environment(\.scenePhase) private var phase



init() {
let appearance = UINavigationBarAppearance()

    appearance.configureWithDefaultBackground()
    
    appearance.shadowColor = .none
    appearance.shadowImage = UIImage()
    appearance.setBackIndicatorImage(UIImage(systemName: "arrowshape.turn.up.backward")?.withTintColor(.white), transitionMaskImage: UIImage(systemName: "arrowshape.turn.up.backward")?.withTintColor(.white))


    UINavigationBar.appearance().standardAppearance = appearance
    
    let tabappearance = UITabBarAppearance()
    tabappearance.backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 0.5)
    tabappearance.shadowColor = .none
    tabappearance.shadowImage = .none
    UITabBar.appearance().standardAppearance = tabappearance
    
}

var body: some Scene {
    
    
WindowGroup {
    GeometryReader { geometry in
        if (libraryData.loaded) {
            ContentView(libraryData: $libraryData, modal: $modal)
            
                .overlay(content: {
                    if modal.artistModal.artist != nil {
                       
                        ArtistExpandedView(modal: $modal, geometry: geometry,  libraryData: $libraryData)
                            .zIndex(100)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .slide))
                    }
                    
                    if modal.albumModal.album != nil  {
                        AlbumExpandedView(modal: $modal, geometry: geometry, libraryData: $libraryData)
                            .zIndex(100)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .slide))
                    }
                    
                    if modal.songModal.song != nil {
                       
                        SongExpandedView(modal: $modal, geometry: geometry, libraryData: $libraryData)
                            .zIndex(100)
                          
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .slide))
                            
                         
                    }
                    
                })
        } else {
            SplashView()
                
        }
    
           
    }
}
.onChange(of: phase) { oldValue, newValue in
    switch newValue {
    case .active:
        print("a")
    case .background:
        schedule()
    case .inactive:
        print("a")
    @unknown default:
        print("a")
    }
}
.backgroundTask(.appRefresh("UpdateListeningHistory")) {
    updateListeningHistory()
}
}
    func schedule() {
        
      
        let request = BGAppRefreshTaskRequest(identifier: "UpdateListeningHistory")
        request.earliestBeginDate = Date.now.endOfDay
        
        do {
          try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
       
    }
    
    func updateListeningHistory()  {
       if (libraryData.loaded) {
            libraryData.realm.writeAsync {
                   libraryData.songs.forEach { song in
          
                           let entry = libraryData.realm.objects(SongListened.self).first { item in
                                item.musicId == song.id.rawValue
                            }
                            
                            if let existingEntry = entry {
                                
                                
                                if let date = song.lastPlayedDate, let playcount = song.playCount, let duration = song.duration {
                                    let entry = existingEntry.playsOverTime.first { item in
                                        item.date == date.startOfDay
                                        
                                    }
                                    
                                    if let existingDate = entry {
                                        existingDate.playCount = playcount
                                        existingDate.minutesListened = playcount * Int(duration/60)
                                    } else {
                                        existingEntry.playsOverTime.append(ListeningData(date:  Date().startOfDay, playCount: song.playCount ?? 0, minutesListened: (Int(song.playCount ?? 0) * Int((song.duration ?? TimeInterval())/60))))
                                    }
                                }
                                
                            } else {
                               
                                let songa = SongListened(musicId: song.id.rawValue, playsOverTime: List<ListeningData>())
                                songa.playsOverTime.append(ListeningData(date: song.lastPlayedDate ?? Date().startOfDay, playCount: song.playCount ?? 0, minutesListened: (Int(song.playCount ?? 0) * Int((song.duration ?? TimeInterval())/60))))
                                libraryData.realm.add(songa)
                            }
                            
                       
                    

                   }
           
           }
          
       }
   }
}




