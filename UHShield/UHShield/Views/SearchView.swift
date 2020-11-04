//
//  SearchView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import FirebaseAuth

struct SearchView: View {
    @State var search = ""
    @Binding var selection: Int
    @StateObject var eventViewModel = EventViewModel()
    @State var searchType = 0 // 0 for all, 1 for name, 2 for sponsor, 3 for location
    
    var body: some View {
        NavigationView {
            
            ZStack {
                List {
                    
                    // search bar section
                    Section {
                        HStack {
                            if searchType == 1 {
                                
                                Image(systemName: "chevron.backward").onTapGesture(perform: {
                                    
                                    withAnimation(.spring()) {
                                        searchType = 0
                                    }
                                })

                                Image(systemName: "text.book.closed")
                            } else if searchType == 2 {
                                Image(systemName: "chevron.backward").onTapGesture(perform: {
                                    withAnimation(.spring()) {
                                        searchType = 0
                                    }
                                })
                                Image(systemName: "person")
                            } else if searchType == 3 {
                                Image(systemName: "chevron.backward").onTapGesture(perform: {
                                    withAnimation(.spring()) {
                                        searchType = 0
                                    }
                                })
                                Image(systemName: "building.2")
                            }
                            
                            SearchBar(text: $search)
                        }
                    }
                    
                    if !search.isEmpty {
                        if searchType == 1 || searchType == 0 {
                            // event name section
                            Section {
                                HStack {
                                    Text("Search by: ")
                                    Text("event name").foregroundColor(.blue)
                                }
                                ForEach(self.eventViewModel.events.filter{$0.eventName!.localizedCaseInsensitiveContains(self.search)}) { event in
                                    EventRowView(event: event)
                                }
                            }
                        }
                        
                        // event sponsor section
                        if searchType == 2 || searchType == 0 {
                            Section {
                                HStack {
                                    Text("Search by: ")
                                    Text("sponsor").foregroundColor(.blue)
                                }
                                ForEach(self.eventViewModel.events.filter{$0.sponsor!.localizedCaseInsensitiveContains(self.search)}) { event in
                                    EventRowView(event: event)
                                }
                            }
                        }
                        
                        // event location section
                        if searchType == 3 || searchType == 0 {
                            Section {
                                HStack {
                                    Text("Search by: ")
                                    Text("location").foregroundColor(.blue)
                                }
                                ForEach(self.eventViewModel.events.filter{$0.location!.building.localizedCaseInsensitiveContains(self.search) || $0.location!.roomID.localizedCaseInsensitiveContains(self.search)}) { event in
                                    EventRowView(event: event)
                                }
                            }
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
                .listStyle(GroupedListStyle())
                .navigationBarItems(leading: Button(action: {selection = 0}, label: {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }))
                .navigationTitle(Text("Search Events"))
                .onAppear {
                    eventViewModel.fetchData()
                }
                
                if search.isEmpty {
                    VStack {
                        Text("Search By Type").foregroundColor(.gray)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], content: {
                            Button(action: { withAnimation(.spring()) { searchType = 1 } }, label: {
                                Text("Event Name")
                            })
                            Button(action: { withAnimation(.spring()) { searchType = 2 } }, label: {
                                Text("Sponsor")
                            })
                            Button(action: { withAnimation(.spring()) { searchType = 3 } }, label: {
                                Text("Location")
                            })
                        } ).padding()
                        
                        Spacer()
                    }.offset(y: UIScreen.main.bounds.height/7)
                }
            }
        }
        
    }

}


struct SearchView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        SearchView(selection: .constant(1))
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
