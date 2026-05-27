//
//  OverviewPDF.swift
//  ParkinsonBuddy
//
//  Created by Chiara on 06/04/23.
//

import SwiftUI
import CareKitStore
import CareKit
import WebKit

struct ListView: View {
    
    var storeManager: OCKSynchronizedStoreManager
    @State var selectedDate = Date()
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: {MonthPickerView(storeManager: self.storeManager)}, label: {ItemCell(text: "Export PDF")})
                
                NavigationLink(destination: {WebView(urlString: "https://www.parkinson.it/morbo-di-parkinson.html")}, label: {ItemCell(text: "What is Parkinson's?")})
                
                NavigationLink(destination: {About()}, label: {ItemCell(text: "About Us")})
                
            }.navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ItemCell: View{
    let text : String
    var body: some View {
        
      Text("\(text)")
    }
}

struct OverviewPDF_Previews: PreviewProvider {
    static var previews: some View {
        ListView(storeManager: OCKSynchronizedStoreManager(wrapping: OCKStore(name: "MyStore", type: .onDisk())))
    }
}
