////
////  Charts.swift
////  prova
////
////  Created by Francesco Ferraù on 11/04/23.
////
import SwiftUI
import Charts

struct TappingDate: Identifiable {
    var type: String
    var day: String
    var count: Double
    var id = UUID()
}


struct BarChart: View {
    @State var date : [TappingDate]
    @State var selectedate : Date
    
    
    var body: some View {
        
            VStack{
                HStack{
                    switch date.first?.type {
                    case Surveys.tappingRight, Surveys.tappingLeft:
                        Text("Digital Finger Tapping Test of \(self.selectedate, formatter: dateFormatter)")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.leading)
                    case Surveys.checkInPainItemIdentifier, Surveys.checkInSleepItemIdentifier:
                        Text("Surveys Answers about Pain and Sleep of \(self.selectedate, formatter: dateFormatter)")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.leading)
                    case Surveys.checkInFatigueItemIdentifier, Surveys.checkInNauseaItemIdentifier:
                        Text("Surveys Answers about Fatigue and Nausea of \(self.selectedate, formatter: dateFormatter)")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.leading)
                    case Surveys.trailMaking, Surveys.trailMakingTime:
                        Text("Trail Making Test of \(self.selectedate, formatter: dateFormatter)")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.leading)
                    case Surveys.memory:
                        Text("Memory Test of \(self.selectedate, formatter: dateFormatter)")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.leading)
                    default:
                        Text("Ciao")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.leading)
                    }
                    
                }               //.padding(.bottom, 20)
                HStack{
                        Chart{
                            ForEach(date, id: \.type){ series in
                                BarMark(x: .value("Day", series.day),
                                        y: .value("Count", series.count))
                                
                                .foregroundStyle(by: .value("Type", series.type))
                                .position(by: .value("Type", series.type))
                            }
                            
                        }.chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 5))
                        }
                        .padding()
                    
                }.padding()
                .frame(maxWidth: 595.2, maxHeight: 600)
                Spacer()
            }.padding()
            .frame(width: 595.2, height: 841.8) // Imposta le dimensioni in punti per il formato A4 a 72dpi
            .multilineTextAlignment(.leading)
            .colorScheme(.light)
            
        
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }
        

}
