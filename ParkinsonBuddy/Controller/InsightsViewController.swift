//
//  ProfileViewController.swift
//  App
//
//  Created by Chiara on 16/02/23.
//

import UIKit
import CareKit
import CareKitUI
import ResearchKit
import CareKitStore


class InsightsViewController: OCKListViewController {
    
    let storeManager: OCKSynchronizedStoreManager
    
    
    
    // Recupera l'istanza di UserDefaults
    let defaults = UserDefaults.standard
    
    
    init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
        
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        
        
        let intervalSeriesRight = OCKDataSeriesConfiguration(
            taskID: TaskIDs.tappingCheck,
            legendTitle: "Right Hand",
            gradientStartColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            gradientEndColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            markerSize: 10,
            eventAggregator: .custom({ dailyEvents -> Double in
                dailyEvents
                    .first?
                    .answer(kind: Surveys.tappingRight)
                ?? 0
            })
        )
        
        
        let intervalSeriesLeft = OCKDataSeriesConfiguration(
            taskID: TaskIDs.tappingCheck,
            legendTitle: "Left Hand",
            gradientStartColor: UIColor.systemBlue,
            gradientEndColor: UIColor.systemBlue,
            markerSize: 10,
            eventAggregator: .custom({ dailyEvents -> Double in
                dailyEvents
                    .first?
                    .answer(kind: Surveys.tappingLeft)
                ?? 0
            })
        )
        
        
        
        
        
        let tapBarChart = OCKCartesianChartViewController(
            plotType: .bar,
            selectedDate: Date(),
            configurations: [intervalSeriesRight, intervalSeriesLeft],
            storeManager: storeManager
        )
        
        
        tapBarChart.chartView.headerView.titleLabel.text = "Number Of Taps Between Per Second"
        
        
        let painSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn,
            legendTitle: "Pain (1-10)",
            gradientStartColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            gradientEndColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            markerSize: 10,
            eventAggregator: .custom({ events in
                events
                    .first?
                    .answer(kind: Surveys.checkInPainItemIdentifier)
                ?? 0
            })
        )
        
        let sleepSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn,
            legendTitle: "Sleep (hours)",
            gradientStartColor: UIColor.systemBlue,
            gradientEndColor: UIColor.systemBlue,
            markerSize: 10,
            eventAggregator: .custom({ events in
                events
                    .first?
                    .answer(kind: Surveys.checkInSleepItemIdentifier)
                ?? 0
            })
        )
        
        
        let survey1BarChart = OCKCartesianChartViewController(
            plotType: .bar,
            selectedDate: Date(),
            configurations: [painSeries, sleepSeries],
            storeManager: storeManager
        )
        
        let fatigueSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn,
            legendTitle: "Fatigue (1-10)",
            gradientStartColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            gradientEndColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            markerSize: 10,
            eventAggregator: .custom({ events in
                events
                    .first?
                    .answer(kind: Surveys.checkInFatigueItemIdentifier)
                ?? 0
            })
        )
        
        let nauseaSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn,
            legendTitle: "Nausea (1-10)",
            gradientStartColor: UIColor.systemBlue,
            gradientEndColor: UIColor.systemBlue,
            markerSize: 10,
            eventAggregator: .custom({ events in
                events
                    .first?
                    .answer(kind: Surveys.checkInNauseaItemIdentifier)
                ?? 0
            })
        )
        
        
        let survey2BarChart = OCKCartesianChartViewController(
            plotType: .bar,
            selectedDate: Date(),
            configurations: [fatigueSeries, nauseaSeries],
            storeManager: storeManager
        )
        
        let trailMakingSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.trailMakingTest,
            legendTitle: "Trail Making",
            gradientStartColor: UIColor.systemBlue,
            gradientEndColor: UIColor.systemBlue,
            markerSize: 10,
            eventAggregator: .custom({ dailyEvents -> Double in
                dailyEvents
                    .first?
                    .answer(kind: Surveys.trailMaking)
                ?? 0
            })
        )
        
        let trailMakingTimeSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.trailMakingTest,
            legendTitle: "Trail Making Time",
            gradientStartColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            gradientEndColor: #colorLiteral(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
            markerSize: 10,
            eventAggregator: .custom({ dailyEvents -> Double in
                dailyEvents
                    .first?
                    .answer(kind: Surveys.trailMakingTime)
                ?? 0
            })
        )
        
        let trailBarChart = OCKCartesianChartViewController(
            plotType: .bar,
            selectedDate: Date(),
            configurations: [trailMakingSeries, trailMakingTimeSeries],
            storeManager: storeManager
        )
        
        let memorySeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.memoryTest,
            legendTitle: "Memory Task Score",
            gradientStartColor: UIColor.systemBlue,
            gradientEndColor: UIColor.systemBlue,
            markerSize: 10,
            eventAggregator: .custom({ dailyEvents -> Double in
                dailyEvents
                    .first?
                    .answer(kind: Surveys.memory)
                ?? 0
            })
        )
        
        let memoryChart = OCKCartesianChartViewController(
            plotType: .bar,
            selectedDate: Date(),
            configurations: [memorySeries],
            storeManager: storeManager
        )
        
        survey1BarChart.chartView.headerView.titleLabel.text = "Pain and Sleep"
        survey2BarChart.chartView.headerView.titleLabel.text = "Fatigue and Nausea"
        trailBarChart.chartView.headerView.titleLabel.text = "Trail Making Test"
        memoryChart.chartView.headerView.titleLabel.text = "Memory Test"
        appendViewController(survey1BarChart, animated: false)
        appendViewController(survey2BarChart, animated: false)
        appendViewController(tapBarChart, animated: false)
        appendViewController(trailBarChart, animated: false)
        appendViewController(memoryChart, animated: false)
    }
}


