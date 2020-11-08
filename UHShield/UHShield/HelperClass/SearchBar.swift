//
//  SearchBar.swift
//  UHShield
//
//  Created by Tianhui Zhou on 11/1/20.
//

import Foundation
import SwiftUI
 
 
struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    class Coordinator: NSObject,UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//                searchBar.resignFirstResponder()
                searchBar.endEditing(true)
            }
    }
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchsBar = UISearchBar(frame: .zero)
        searchsBar.delegate = context.coordinator
        searchsBar.showsCancelButton = true
        return searchsBar
        
    }
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
}
