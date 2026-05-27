//
//  About.swift
//  ParkinsonBuddy
//
//  Created by Francesco Ferraù on 13/04/23.
//

import SwiftUI

struct About: View {
    var body: some View {
            ScrollView{
                    HStack{
                        Text("ParkinsonBuddy is an app developed to assist individuals diagnosed with Parkinson's disease in monitoring their condition. This app is designed to be used by individuals who have already received a Parkinson's diagnosis and are looking for a convenient way to track the progression of their symptoms over time.\n\nParkinsonBuddy includes a variety of tools and resources to help users manage their Parkinson's disease. For example, the app provides access to educational materials about Parkinson's disease, as well as information about medications commonly used to treat the condition.\n\nOverall, ParkinsonBuddy is a valuable tool for individuals with Parkinson's disease who are looking for a convenient and effective way to monitor their condition. By tracking changes in symptoms over time, users can work with their healthcare providers to adjust treatment plans and manage their condition more effectively.\n\nIt was created during the Apple Foundation course at the University of Salerno and completed by developers Francesco Ferraù and Chiara Ferraioli.")
                    }.font(.body)
                        .padding()
                    Spacer()
                    .navigationTitle("About Us")
                    .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
