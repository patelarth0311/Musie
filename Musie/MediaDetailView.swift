//
//  MediaDetailView.swift
//  Musie
//
//  Created by Arth Patel on 8/13/23.
//

import SwiftUI
import Charts

enum Selections {
    case overview
    case top
}

struct NavView : View {
@State var expand = false
@Namespace var namespace
init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .clear
    appearance.shadowColor = .clear
  
    appearance.setBackIndicatorImage(UIImage(systemName: "arrowshape.turn.up.backward")?.withTintColor(.white), transitionMaskImage: UIImage(systemName: "arrowshape.turn.up.backward")?.withTintColor(.white))
 
    UINavigationBar.appearance().standardAppearance = appearance
    
    let tabappearance = UITabBarAppearance()
    tabappearance.configureWithTransparentBackground()
    
    UITabBar.appearance().standardAppearance = tabappearance
    
}
    @State var show = false
    @State var selection : Selections = .overview
var body: some View {
    
    GeometryReader { geometry in
        NavigationStack {
            TabView(selection: $selection) {
               
                
                VStack {
                    Button {
                        withAnimation(.smooth) {
                            show.toggle()
                        }
                      
                    } label: {
                        Text("tAPME")
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .background(.black)
                    
                .tag(Selections.top)
                    
            }
            
            .overlay {
                if show {
                    ExpandedViewd(expand: $expand, geometry: geometry, animation: namespace, show: $show)
                        .transition(.move(edge: .bottom))
                      
                }
                
            }
            .toolbar {
                if !show {
                    ToolbarItem(placement: .bottomBar) {
                        HStack(alignment: .top, spacing: 0) {
                            
                            Spacer()
                            Image(systemName: "music.note")
                                .onTapGesture {
                                    selection = .overview
                                }
                            Spacer()
                            Image(systemName: "music.quarternote.3")
                                .onTapGesture {
                                    selection = .top
                                }
                            Spacer()
                        }
                        
                        
                        .foregroundStyle(.pink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        
                        .background(.ultraThickMaterial)
                        .environment(\.colorScheme, .dark)
                        
                        
                        .cornerRadius(16)
                        .padding([.leading,.trailing],10)
                        
                    }
                }
            }
            
           

            
            
            
        }
       
           
        
    }
  
}
}

struct FullSheetView : View {
    
    @Namespace var namespace
    @State var show = false
    @State var index = 0
    @State var query = ""
    var body: some View {
        NavigationView {
            VStack {
               
                    List(0...8, id: \.self) { index in
                            HStack {
                                
                                Image("kickback")
                                    .resizable()
                                
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 55)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                
                                
                                
                                    .shadow(color: .black.opacity(0.2), radius: 20)
                                    .padding(5)
                                    .matchedGeometryEffect(id: index, in: namespace)
                                
                                
                                HStack {
                                    VStack(alignment: .leading)  {
                                        Text("KICKBACK")
                                           
                                            .font(.custom("VarelaRound-Regular", size: 20))
                                        
                                        Text("Kenshi Yoshu")
                                            .font(.custom("Poppins-Regular", size: 15))
                                            .fontWeight(.bold)
                                    }
                                    .fixedSize()
                                    
                                    Button {
                                        withAnimation(.bouncy) {
                                            show.toggle()
                                            self.index = index
                                        }
                                    } label: {
                                        Text("Open")
                                    }
                                    
                                }
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.white)
                            .matchedGeometryEffect(id: index.description + "bg", in: namespace)
                            .musicItemCardStyle(specBG: .avgColor, color: .red )
                               
                           
                        }
                    
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                    
                    .background(Color(red: 1, green: 1, blue: 1))
                       
                  
                    .navigationTitle("Songss")
                    .searchable(text: $query)
                   
                   
                 
                }
            
        }
        .overlay {
            if show {
                VStack {
                    
                    Capsule()
                        .foregroundStyle(.thinMaterial)
                        .frame(width: 50, height: 8)
                    
                    Image("kickback")
                        .resizable()
                    
                        .aspectRatio(contentMode: .fit)
                    
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    
                    
                    
                        .shadow(color: .black.opacity(0.2), radius: 20)
                        .padding(5)
                        .matchedGeometryEffect(id: index, in: namespace)
                    
                    VStack {
                        Button {
                            withAnimation {
                                show.toggle()
                                
                            }
                        } label: {
                            Text("Open")
                        }
                        
                        VStack(alignment: .leading)  {
                            Text("KICKBACK")
                                .font(.system(size: 20,weight: .bold))
                            Text("Kenshi Yoshu")
                                .font(.system(size: 20,weight: .medium))
                        }
                        .fixedSize()
                        
                    }
                    Spacer()
                }
              
                .matchedGeometryEffect(id: index.description + "bg", in: namespace)
                .background(.red)
               
              
            }
        }
        

    }
}
struct ExpandedViewd : View {
@State private var number: Double = 0
@Binding var expand: Bool
var geometry: GeometryProxy
var animation : Namespace.ID
    @Binding var show: Bool
var body: some View {
    NavigationView {
        ScrollView {
            VStack(spacing: 14) {
                
                Image("kickback")
                    .resizable()
                
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .animation(.spring, value: expand)
               
                    .matchedGeometryEffect(id: "art", in: animation)
                    .opacity(0)
                    .shadow(color: .black.opacity(0.2), radius: 20)
                    .onTapGesture {
                        
                        withAnimation(.smooth){
                            number = 1234
                            show.toggle()
                            
                        }
                    }
                HStack {
                    VStack(alignment: .leading)  {
                        Text("KICKBACK")
                            .font(.system(size: 20,weight: .bold))
                        Text("Kenshi Yoshu")
                            .font(.system(size: 20,weight: .medium))
                    }
                    .fixedSize()
                    Spacer()
                }
               
                
                
                .matchedGeometryEffect(id: "text" , in: animation)
                
              
                Spacer()
                    .frame(height: 0)
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Last Played")
                                .font(.system(.headline,weight: .semibold))
                            Spacer()
                        }
                        
                        
                        
                        Text("March 11, 2023")
                            .font(.system(size: 1000, weight: .bold))
                            .minimumScaleFactor(0.005)
                            .lineLimit(1)
                        
                        
                        
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Added")
                                .font(.system(.headline,weight: .semibold))
                            Spacer()
                        }
                        
                        
                        
                        Text("March 11, 2023")
                            .font(.system(size: 1000, weight: .bold))
                            .minimumScaleFactor(0.005)
                            .lineLimit(1)
                        
                        
                        
                    }
                }
                Spacer()
                    .frame(height: 0)
                VStack(spacing: 10) {
                    
                    InsightView(title: "Play Count", geometry: geometry, number: number)
                    
                    InsightView(title: "Minutes Listened", geometry: geometry, number: number)
                    
                    
                }
                
                Spacer()
            }
            
            .padding([.leading,.trailing])
            .padding(.top, 95)
        }
       
       
        .frame(minWidth: geometry.size.width, maxHeight: .infinity)
        .background(.red)
        .coordinateSpace(name: "scroll")
       
        .toolbar(.hidden, for: .tabBar)
        .foregroundStyle(.white)
        .animation(.spring, value: expand)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .ignoresSafeArea(.all)
        .scrollIndicators(.hidden)
       
 
     
        .onTapGesture {
            withAnimation(.bouncy(duration: 0.5)){
                
                expand.toggle()
            }
        }
        .transition(.move(edge: .bottom))
        .onAppear {
            withAnimation(.bouncy) {
                number = 10
            }
        }
    }
    
    
    .clipShape(RoundedRectangle(cornerRadius: 30))
    .ignoresSafeArea(.all)
   
}
        
    
}



struct StatsView : View, Animatable {
    
    var number: Double
    var animatableData: Double {
    get {number}
    set {number = newValue}
    }
    var show : Bool
    var title: String
    var stat: String
    var geometry: GeometryProxy
    @State var idk = 0;
    @State var dum = 0.0
    @State var toshow = 0;
    @Namespace var namespace
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
        Spacer()
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(.title3,weight: .bold))
                        
                        
                            .lineLimit(1)
                        Text("\(Int(dum))")
                        
                            .font(.system(size: 70 , weight: .bold))
                            .minimumScaleFactor(0.05)
                            .lineLimit(1)
                    }
                    Spacer()
                }
               
            }
            .padding(.leading,10)
            
          
            
      
             
           
            if show {
           
                HStack(alignment: .bottom) {
                    
                   Spacer()
                    if (toshow == idk) {
                        
                        VStack(alignment: .leading) {
                            Image(idk % 2 == 0 ? "trav" : "SZA-SOS")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                                .shadow(color: .black.opacity(0.2), radius: 20)
                                .overlay(alignment: .bottomTrailing) {
                                    HStack(alignment: .bottom) {
                                      
                                        Text("0")
                                            .font(.system(size: 50 , weight: .bold))
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                        
                                    }
                                   
                                    .padding(.horizontal, 2)
                                }
                            HStack(alignment: .bottom) {
                              
                                   
                                VStack(alignment: .leading){
                                    Text("UTOPIA")
                                        .font(.system(size:35 , weight: .bold))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                      
                                       
                                    
                                    Text("Travis Scott")
                                        .font(.system(size: 25 , weight: .bold))
                                        .minimumScaleFactor(0.05)
                                        .lineLimit(1)
                                       
                                        
                                       
                                }
                              
                                
                                
                            }
                           
                              
                            
                            
                           
                             
                        }
                       
                        .frame(width: (Double(Int(UIScreen.main.bounds.width - 105))))
                        .matchedGeometryEffect(id: toshow, in: namespace)
                    }
                    
                        VStack {
                            ForEach(0...4, id: \.self) { index in
                                
                                if (index != idk ) {
                                    Image( index % 2 == 0 ? "trav" : "SZA-SOS")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                 
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.2), radius: 20)
                                       
                                       
                                        .onTapGesture {
                                            withAnimation(.bouncy(duration: 1)) {
                                                idk = index
                                                toshow = index
                                            }
                                           
                                        }
                                        .overlay(alignment: .bottomTrailing) {
                                            HStack(alignment: .bottom) {
                                              
                                                Text("0")
                                                    .font(.system(size: 20 , weight: .bold))
                                                    .minimumScaleFactor(0.05)
                                                    .lineLimit(1)
                                                
                                            }
                                           
                                            .padding(.horizontal, 2)
                                        }
                                       
                                        .matchedGeometryEffect(id: index, in: namespace)
                                      
                                    
                                }
                                
                             
                            }
                            Spacer()
                        }
                    Spacer()
                    }
              
                
                
                
            }
             
               
               
                
            
           
        }
       
        .task {
         
            withAnimation(.easeIn) {
                self.dum = number
            }
        }
       
       
       
        .foregroundStyle(.white)
       
    }
}

struct Artists : Identifiable {
    var id = UUID()
    let name: String
    let playCount: Double
}

struct DownloadDate : Identifiable {
    var id = UUID()
    var date : Date
    var count: Int
}

struct Bars: View {
    
    
    var dateComponent = Calendar.current.dateComponents([.day,.month], from: Date())
    
    var dates = [DownloadDate(date: Date(timeInterval: 86400, since: .now), count: 2),DownloadDate(date: Date(timeInterval: 20000, since: .now), count: 20)]
    
    var artists = [Artists(name: "Travis", playCount: 4343),Artists(name: "SZA", playCount: 5033)
                   ,Artists(name: "Ice Spce", playCount: 443)]
        
    var body: some View {
        VStack {
        
            Chart(dates) { date in
                BarMark(x: .value("Date", date.date,  unit: .month), y: .value("Count", 1))
            }
            
            Chart(artists) { artist in
                BarMark(x: .value("Artist", artist.name) , y: .value("Playcount",artist.playCount), width: 30)
                    .annotation(position: .top, alignment: .center, spacing: 10) {
                        VStack {
                            Image("SZA-SOS")
                                .resizable()
                                
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 55)
                                .clipShape(RoundedRectangle(cornerRadius: 55))
                            
                                .shadow(color: .black.opacity(0.2), radius: 20)
                            Text("\(Int(artist.playCount), format: .number)")
                                .foregroundStyle(.white)
                        }
                        
                    }
                    .foregroundStyle(Gradient(colors: [Color(UIImage(named: "SZA-SOS")!.averageColor!.cgColor),Color(UIImage(named: "SZA-SOS")!.averageColor!.cgColor).opacity(0.7)]))
                    .cornerRadius(3)
                
                    
                
                   
                   
                    
            }
            .chartXAxis(.automatic)
            
            .chartYAxis(.hidden)
            .padding()
            
        }
    }
}
struct Stats : View {
 @State var query = ""
    var gridItemLayout = [GridItem(.flexible())]
    var body: some View {
        
       
            
            
            NavigationView {
                GeometryReader { proxy in
                  
                ScrollView(.vertical,showsIndicators: false) {
                    Bars()
                        
                    VStack(alignment: .leading) {
                            
                            LazyVGrid(columns: gridItemLayout, spacing: 2) {
                                HStack {
                                    StatsView(number: 129850, show: false, title: "Minutes listened",stat:  "123400", geometry: proxy)
                                    Spacer()
                                    StatsView(number: 36504,show: false, title: "Play count",stat:  "1000", geometry: proxy)
                                }
                               
                                
                                StatsView(number: 1504,show: true, title: "Songs",stat:  "1000", geometry: proxy)
                                
                                StatsView(number: 108, show: true, title: "Artists",stat:  "1000", geometry: proxy)
                                
                                StatsView(number: 273, show: true, title: "Albums",stat:  "1000", geometry: proxy)
                                
                                
                            }
                            
                        }
                        .padding(5)
                        
                        
                        
                    
                }
                
                .background(Color(red: 0.07, green: 0.07, blue: 0.07))
                .navigationTitle("Overview")
                .tint(.white)
            }
                
            .tint(.white)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        HStack(alignment: .center) {
                        // Space Between
                            Spacer()
                        Image(systemName: "waveform")
                                .font(.system(size: 20))
                                .padding()
                        Spacer()
                            Image(systemName: "waveform")
                                    .font(.system(size: 20))
                                    .padding()
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(.ultraThickMaterial)
                        .cornerRadius(50)
                    }
                }
            }
        }
    }
}


struct Splashy : View {
    @Binding var show : Bool
    var body: some View {
        VStack(alignment: .center) {
            Text("MUSIE")
            Button {
                withAnimation {
                    show.toggle()
                }
              
            } label: {
             Text("Click")
            }

        }
      
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .push(from: .bottom)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
       
      
        .background(.pink)
        .clipShape(RoundedRectangle(cornerRadius: 30.0))
        .ignoresSafeArea(.all)
        
    }
}

struct Container : View {
    @State var show = false
    var body: some View {
        if show {
            VStack {
                Text("Parent")
                    .onTapGesture {
                        withAnimation {
                            show.toggle()
                        }
                       
                    }
            }
        } else {
            Splashy(show: $show)
                
        }
    }
}

