import SwiftUI

struct DictDetailScreen: View {
    
    let dict: Dictionaries
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text(dict.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Divider()
                
                Text(dict.description)
                    .font(.body)
                    .foregroundStyle(.black)
                    
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Your Dictionary Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DictDetailScreen(dict: Dictionaries.init(title: "Test", description: "Test"))
}
