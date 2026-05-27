//
//  MonthPickerView.swift
//  ParkinsonBuddy
//
//  Created by Chiara on 06/04/23.
//

import UIKit
import SwiftUI
import MonthYearWheelPicker
import CareKit
import CareKitStore
import PDFKit
import Charts

class MonthYearPickerCoordinator: NSObject {
    var parent: MonthYearPicker

    init(_ parent: MonthYearPicker) {
        self.parent = parent
    }
    
    @objc func handlePickerValueChange(_ sender: MonthYearWheelPicker) {
        
        parent.selectedDate = sender.date
    }
}

struct MonthYearPicker: UIViewRepresentable {
    typealias UIViewType = MonthYearWheelPicker

    @Binding var selectedDate: Date
    
    var minimumDate: Date{
        var components = DateComponents()
        components.year = 2022
        components.month = 01
        components.day = 31
        components.hour = 22
        components.minute = 30
        components.timeZone = TimeZone(identifier: "UTC")
        return Calendar.current.date(from: components) ?? Date()
    }
    
    let maximumDate = Date()
    
    func makeUIView(context: Context) -> MonthYearWheelPicker {
        let picker = MonthYearWheelPicker()
        picker.minimumDate = minimumDate
        picker.maximumDate = maximumDate
        let coordinator = MonthYearPickerCoordinator(self)
        picker.addTarget(coordinator, action: #selector(MonthYearPickerCoordinator.handlePickerValueChange(_:)), for: .valueChanged)
        picker.date = selectedDate
        return picker
    }
    
    func updateUIView(_ uiView: MonthYearWheelPicker, context: Context) {
        uiView.date = selectedDate
    }
}


struct MonthPickerView: View{
    var storeManager: OCKSynchronizedStoreManager
    
//    @State private var selectedDate = Calendar.current.date(byAdding: .day, value: -Calendar.current.dateComponents([.day], from: (Calendar.current.dateInterval(of: .month, for: Date()) ?? DateInterval.init()).start, to: Date()).day!, to: Date()) ?? Date()
    @State private var selectedDate = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date()) ?? Date()
    
    @State private var showCharts = false
    @State private var showAlert = false

    
    init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
//        self._fetcher = State(initialValue: ManualFetch(storeManager: storeManager))
    }
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("To export data for a specific date, select the corresponding month and year from the picker. Once you have selected the date, you can export the data for the selected month and year in PDF format by clicking on the 'Export' button.")
                }.font(.body)
                    .padding(.top, 20)
                    .padding()
                HStack{
                    MonthYearPicker(selectedDate: $selectedDate)
                        .frame(width: 200, height: 200)
                }.padding(.bottom, 60)
                    .padding(.top, 60)
                HStack{
                    Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                }.font(.title2)
                    .bold()
                Spacer()
                
            }.navigationTitle("Pick month and year")
        }.navigationTitle("Export PDF")
            .navigationBarItems(trailing: Button("Export") {
                self.exportPDF(){ result in
                    showAlert = result
                }
                    
            }).alert(isPresented: $showAlert){
                Alert(title: Text("Warning").foregroundColor(.red), message: Text("You can't choose a date prior to the download of the app"), dismissButton: .default(Text("OK")))
            }
            
    }
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }
    
    func exportPDF(completion: @escaping (Bool) -> Void){
        
        let fetcher = ManualFetch(storeManager: self.storeManager)
        var checkin1Array = [TappingDate]()
        var checkin2Array = [TappingDate]()
        var tappingArray = [TappingDate]()
        var trailArray = [TappingDate]()
        var memoryArray = [TappingDate]()
        
        let rightDate = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: selectedDate) ?? selectedDate
        
        var interval = Calendar.current.dateInterval(of: .month, for: rightDate) ?? DateInterval.init()

        let selectedMonth = Calendar.current.component(.month, from: rightDate)
        

        switch selectedMonth {
        case 1, 2, 3, 11, 12:
            interval.start = Calendar.current.date(byAdding: .hour, value: 1, to: interval.start) ?? Date()
        default:
            interval.start = Calendar.current.date(byAdding: .hour, value: 2, to: interval.start) ?? Date()
        }

        let daysInMonth = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day!

        switch selectedMonth {
        case 3:
            interval.end = Calendar.current.date(byAdding: .hour, value: -2, to: interval.end) ?? interval.end
            interval.end = Calendar.current.date(byAdding: .second, value: 3599, to: interval.end) ?? interval.end
        case 10:
            interval.end = Calendar.current.date(byAdding: .hour, value: -3, to: interval.end) ?? interval.end
            interval.end = Calendar.current.date(byAdding: .second, value: -1, to: interval.end) ?? interval.end
        default:
            interval.end = Calendar.current.date(byAdding: .second, value: -1, to: interval.end) ?? interval.end
            interval.end = Calendar.current.date(byAdding: .hour, value: -2, to: interval.end) ?? interval.end
        }
        
        
        
        fetcher.fetch(interval: interval, daysInMonth: daysInMonth){ errorFetch in
            
            checkin1Array.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.checkIn,kind: Surveys.checkInPainItemIdentifier))
            
            checkin1Array.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.checkIn, kind: Surveys.checkInSleepItemIdentifier))
            
            checkin2Array.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.checkIn,kind: Surveys.checkInFatigueItemIdentifier))
            
            checkin2Array.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.checkIn, kind: Surveys.checkInNauseaItemIdentifier))
            
            tappingArray.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.tappingCheck, kind: Surveys.tappingRight))
            
            tappingArray.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.tappingCheck, kind: Surveys.tappingLeft))
            
            trailArray.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.trailMakingTest, kind: Surveys.trailMaking))

            trailArray.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.trailMakingTest, kind: Surveys.trailMakingTime))
            
            memoryArray.append(contentsOf: fetcher.retrieveOutcome(taskID: TaskIDs.memoryTest, kind: Surveys.memory))
            
            if !errorFetch{
                var pdfView = PDFView()
                var pdfDocument = PDFDocument()

                // Add each chart as a page to the PDF document
                for chartData in [checkin1Array, checkin2Array, tappingArray, trailArray, memoryArray] {
                    let chartController = UIHostingController(rootView: BarChart(date: chartData, selectedate: selectedDate))
                    let chartView = chartController.view!
                    let chartSnapshot = self.snapshot(of: chartView)
                    _ = UIImageView(image: chartSnapshot)
                    let chartPDFData = self.pdfData(from: chartView)
                    let pdfPage = PDFPage(image: chartSnapshot)
                    pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
                }

                // Save the PDF file to a temporary URL
                pdfView.document = pdfDocument
                let pdfData = pdfView.document?.dataRepresentation()
                let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("chart.pdf")
                try? pdfData?.write(to: temporaryURL, options: .atomic)

                
                let activityVC = UIActivityViewController(activityItems: [temporaryURL], applicationActivities: nil)
                activityVC.completionWithItemsHandler = { _, _, _, _ in
                    do {
                        try FileManager.default.removeItem(at: temporaryURL)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                
                completion(false)
            } else{
                completion(true)
            }
            
        }
    }

    func snapshot(of view: UIView) -> UIImage {
        let size = CGSize(width: view.intrinsicContentSize.width, height: view.intrinsicContentSize.height)
        view.bounds = CGRect(origin: .zero, size: size)
        view.backgroundColor = .white
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    func pdfData(from view: UIView) -> Data {
        let pdfPageBounds = CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: 11 * 72.0)
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPage()
        guard let pdfContext = UIGraphicsGetCurrentContext() else { fatalError("Unable to get PDF context") }
        
        view.layer.render(in: pdfContext)
        
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }

    }

extension UIView {
    func pdfData() -> Data {
        let pdfPageBounds = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return Data() }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}

    
    
    struct MonthPickerView_Previews: PreviewProvider {
        
        static var previews: some View {
            MonthPickerView(storeManager: OCKSynchronizedStoreManager(wrapping: OCKStore(name: "MyStore", type: .onDisk())))
        }
    }
