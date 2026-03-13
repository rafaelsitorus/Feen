import SwiftUI

struct DictionaryScreen: View {
    
    let dicts: [Dictionaries]
    
    @State private var centeredWord: String?
    
    var groupedDicts: [String: [Dictionaries]] {
        Dictionary(grouping: dicts) { String($0.title.prefix(1)).uppercased() }
    }
    
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
    
    func checkCenter(mid: CGFloat, word: String, scrollCenter: CGFloat) {
        if abs(mid - scrollCenter) < 20 {
            centeredWord = word
        }
    }
    
    var body: some View {
        
        ScrollViewReader { proxy in
            
            HStack(alignment: .center) {
                
                GeometryReader { screenGeo in
                    
                    let scrollHeight = screenGeo.size.height * 0.6
                    let scrollCenter = scrollHeight / 2
                    
                    VStack {
                        
                        Spacer()
                        
                        ScrollView {
                            
                            LazyVStack(spacing: 30) {
                                Color.clear.frame(height: scrollCenter)
                                ForEach(alphabet, id: \.self) { letter in
                                    
                                    if let items = groupedDicts[letter] {
                                        
                                        VStack(spacing: 16) {
                                            
                                            //                                            Text(letter)
                                            //                                                .font(.title)
                                            //                                                .foregroundStyle(.black)
                                            //                                                .id(letter)
                                            
                                            ForEach(items) { dict in
                                                
                                                NavigationLink {
                                                    DictDetailScreen(dict: dict)
                                                } label: {
                                                    
                                                    Text(dict.title)
                                                        .font(.largeTitle)
                                                        .foregroundStyle(.black)
                                                        .underline(centeredWord == dict.title)
                                                        .fontWeight(centeredWord == dict.title ? .bold : .regular)
                                                        .background(
                                                            GeometryReader { geo in
                                                                Color.clear
                                                                    .onAppear {
                                                                        
                                                                        let mid = geo.frame(in: .named("scroll")).midY
                                                                        
                                                                        checkCenter(
                                                                            mid: mid,
                                                                            word: dict.title,
                                                                            scrollCenter: scrollCenter
                                                                        )
                                                                    }
                                                                    .onChange(of: geo.frame(in: .named("scroll")).midY) { _, newMid in
                                                                        
                                                                        checkCenter(
                                                                            mid: newMid,
                                                                            word: dict.title,
                                                                            scrollCenter: scrollCenter
                                                                        )
                                                                    }
                                                            }
                                                        )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Color.clear
                                    .frame(height: scrollCenter)
                        }
                        .coordinateSpace(name: "scroll")
                        .frame(height: scrollHeight)
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .black, location: 0.4),
                                    .init(color: .black, location: 0.6),
                                    .init(color: .clear, location: 1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        Spacer()
                    }
                }
                
                VStack(spacing: 2) {
                    
                    ForEach(alphabet, id: \.self) { letter in
                        
                        Text(letter)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .onTapGesture {
                                
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }
                    }
                }
                .padding(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 26,
                    trailing: 12
                ))
            }
        }
    }
}

#Preview {
    NavigationStack {
        DictionaryScreen(dicts: dictsData)
    }
}
