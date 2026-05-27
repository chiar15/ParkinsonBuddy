//
//  Surveys.swift
//  App
//
//  Created by Biagio Marra on 22/02/23.
//

import Foundation
import ResearchKit
import CareKit
import CareKitStore

struct Surveys {
    
    private init() {}
    
    // ONBOARD TASK
    static func onboardingSurvey() -> ORKTask {

        // The Welcome Instruction step.
        let welcomeInstructionStep = ORKInstructionStep(
            identifier: "onboarding.welcome"
        )

        welcomeInstructionStep.title = "Welcome!"
        welcomeInstructionStep.detailText = "Thank you for joining our study. Tap Next to learn more before signing up."
        welcomeInstructionStep.image = UIImage(named: "welcome-image")
        welcomeInstructionStep.imageContentMode = .scaleAspectFill

        // The Informed Consent Instruction step.
        let studyOverviewInstructionStep = ORKInstructionStep(
            identifier: "onboarding.overview"
        )

        studyOverviewInstructionStep.title = "Before You Join"
        studyOverviewInstructionStep.iconImage = UIImage(systemName: "checkmark.seal.fill")

        let heartBodyItem = ORKBodyItem(
            text: "The study will ask you to share some of your health data.",
            detailText: nil,
            image: UIImage(systemName: "heart.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        let completeTasksBodyItem = ORKBodyItem(
            text: "You will be asked to complete various tasks over the duration of the study.",
            detailText: nil,
            image: UIImage(systemName: "checkmark.circle.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        let signatureBodyItem = ORKBodyItem(
            text: "Before joining, we will ask you to sign an informed consent document.",
            detailText: nil,
            image: UIImage(systemName: "signature"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        let secureDataBodyItem = ORKBodyItem(
            text: "Your data is kept private and secure.",
            detailText: nil,
            image: UIImage(systemName: "lock.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        studyOverviewInstructionStep.bodyItems = [
            heartBodyItem,
            completeTasksBodyItem,
            signatureBodyItem,
            secureDataBodyItem
        ]

        // The Signature step (using WebView).
        let webViewStep = ORKWebViewStep(
            identifier: "onboarding.signatureCapture",
            html: informedConsentHTML
        )

        webViewStep.showSignatureAfterContent = true

        // The Request Permissions step.
        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]

        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]

        let healthKitPermissionType = ORKHealthKitPermissionType(
            sampleTypesToWrite: healthKitTypesToWrite,
            objectTypesToRead: healthKitTypesToRead
        )

        let notificationsPermissionType = ORKNotificationPermissionType(
            authorizationOptions: [.alert, .badge, .sound]
        )

        let motionPermissionType = ORKMotionActivityPermissionType()

        let requestPermissionsStep = ORKRequestPermissionsStep(
            identifier: "onboarding.requestPermissionsStep",
            permissionTypes: [
                healthKitPermissionType,
                notificationsPermissionType,
                motionPermissionType
            ]
        )

        requestPermissionsStep.title = "Health Data Request"
        requestPermissionsStep.text = "Please review the health data types below and enable sharing to contribute to the study."

        // Completion Step
        let completionStep = ORKCompletionStep(
            identifier: "onboarding.completionStep"
        )

        completionStep.title = "Enrollment Complete"
        completionStep.text = "Thank you for enrolling in this study. Your participation will contribute to meaningful research!"

        let surveyTask = ORKOrderedTask(
            identifier: TaskIDs.onboarding,
            steps: [
                welcomeInstructionStep,
                studyOverviewInstructionStep,
                webViewStep,
                requestPermissionsStep,
                completionStep
            ]
        )

        return surveyTask
    }

    //CHECK-IN TASK
    
    static let checkInFormIdentifier = "checkin.form"
    static let checkInPainItemIdentifier = "Pain"
    static let checkInSleepItemIdentifier = "Sleep"
    static let checkInFatigueItemIdentifier = "Fatigue"
    static let checkInNauseaItemIdentifier = "Nausea"
    
    static func checkInSurvey() -> ORKTask {

        let painAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 10,
            minimumValue: 1,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: "Very painful",
            minimumValueDescription: "No pain"
        )

        let painItem = ORKFormItem(
            identifier: checkInPainItemIdentifier,
            text: "How would you rate your pain?",
            answerFormat: painAnswerFormat
        )
        painItem.isOptional = false

        let sleepAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 12,
            minimumValue: 0,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: nil,
            minimumValueDescription: nil
        )

        let sleepItem = ORKFormItem(
            identifier: checkInSleepItemIdentifier,
            text: "How many hours of sleep did you get last night?",
            answerFormat: sleepAnswerFormat
        )
        sleepItem.isOptional = false
        
        let fatigueAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 10,
            minimumValue: 1,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: "Very fatigued",
            minimumValueDescription: "No fatigue"
        )

        let fatigueItem = ORKFormItem(
            identifier: checkInFatigueItemIdentifier,
            text: "How would you rate your fatigue?",
            answerFormat: fatigueAnswerFormat
        )
        fatigueItem.isOptional = false
        
        let nauseaAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 10,
            minimumValue: 1,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: "Very nauseated",
            minimumValueDescription: "No nausea"
        )

        let nauseaItem = ORKFormItem(
            identifier: checkInNauseaItemIdentifier,
            text: "How would you rate your nausea?",
            answerFormat: nauseaAnswerFormat
        )
        nauseaItem.isOptional = false

        let formStep = ORKFormStep(
            identifier: checkInFormIdentifier,
            title: "Check In",
            text: "Please answer the following questions."
        )
        formStep.formItems = [painItem, sleepItem, fatigueItem, nauseaItem]
        formStep.isOptional = false

        let surveyTask = ORKOrderedTask(
            identifier: TaskIDs.checkIn,
            steps: [formStep]
        )

        return surveyTask
    }
    
    static func extractAnswersFromCheckInSurvey(
        _ result: ORKTaskResult) -> [OCKOutcomeValue]? {

        guard
            let response = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .first(where: { $0.identifier == checkInFormIdentifier }),

            let scaleResults = response
                .results?.compactMap({ $0 as? ORKScaleQuestionResult }),

            let painAnswer = scaleResults
                .first(where: { $0.identifier == checkInPainItemIdentifier })?
                .scaleAnswer,

            let sleepAnswer = scaleResults
                .first(where: { $0.identifier == checkInSleepItemIdentifier })?
                .scaleAnswer,
            
            let fatigueAnswer = scaleResults
                .first(where: { $0.identifier == checkInFatigueItemIdentifier })?
                .scaleAnswer,

            let nauseaAnswer = scaleResults
                .first(where: { $0.identifier == checkInNauseaItemIdentifier })?
                .scaleAnswer
        else {
            assertionFailure("Failed to extract answers from check in survey!")
            return nil
        }

        var painValue = OCKOutcomeValue(Double(truncating: painAnswer))
        painValue.kind = checkInPainItemIdentifier

        var sleepValue = OCKOutcomeValue(Double(truncating: sleepAnswer))
        sleepValue.kind = checkInSleepItemIdentifier
        
        var fatigueValue = OCKOutcomeValue(Double(truncating: fatigueAnswer))
        fatigueValue.kind = checkInFatigueItemIdentifier

        var nauseaValue = OCKOutcomeValue(Double(truncating: nauseaAnswer))
        nauseaValue.kind = checkInNauseaItemIdentifier

        return [painValue, sleepValue, fatigueValue, nauseaValue]
    }
    
    
    //TAPPING TASK
    static let tappingLeft = "Left Hand"
    static let tappingRight = "Right Hand"
    
        static func tappingCheck() -> ORKTask {
            
            let tappingTask = ORKOrderedTask.twoFingerTappingIntervalTask(
                withIdentifier: TaskIDs.tappingCheck,
                intendedUseDescription: nil,
                duration: 10,
                handOptions: .both,
                options: []
            )
            
            return tappingTask
        }
        
    static func extractTappingOutcome(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
        
        guard let tappingResultRight = result.results?
            .compactMap({$0 as? ORKStepResult})
            .first(where: {$0.identifier == "tapping.right"})
            .flatMap({$0.results})?
            .compactMap({$0 as? ORKTappingIntervalResult})
            .first else{
            
            assertionFailure("Failed to parse a tapping interval result")
                     return nil
        }

        guard let tappingResultLeft = result.results?
            .compactMap({$0 as? ORKStepResult})
            .first(where: {$0.identifier == "tapping.left"})
            .flatMap({$0.results})?
            .compactMap({$0 as? ORKTappingIntervalResult})
            .first else{
            
            assertionFailure("Failed to parse a tapping interval result")
                     return nil
        }
        
        
        var countsRight = OCKOutcomeValue(tappingResultRight.samples!.count)
        var countsLeft = OCKOutcomeValue(tappingResultLeft.samples!.count)
        
        countsRight.kind = tappingRight
        countsLeft.kind = tappingLeft
        
        return [countsRight, countsLeft]
    }
    
    static let trailMaking = "Trail Making (%)"
    static let trailMakingTime = "Trail Making Time (sec)"
    
    static func trailMakingTask() -> ORKTask {
        let trailMakingTask = ORKOrderedTask.trailmakingTask(withIdentifier: TaskIDs.trailMakingTest,
            intendedUseDescription: nil,
            trailmakingInstruction: "Trail Making Test",
            trailType: ORKTrailMakingTypeIdentifier.A,
            options: [])
        
        return trailMakingTask
    }
    
    
    static func extractTrailMakingOutcome(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
        
        guard let trailMakingResult = result.results?
            .compactMap({ $0 as? ORKStepResult })
            .compactMap({ $0.results })
            .flatMap({ $0 })
            .compactMap({ $0 as? ORKTrailmakingResult })
            .first else {

            assertionFailure("Failed to parse range of motion result")
            return nil
        }
        
        let numberOfTaps = Double(trailMakingResult.taps.count)
        let numberOfErrors = Double(trailMakingResult.numberOfErrors)
        let perc = ((numberOfTaps - numberOfErrors)/numberOfTaps) * 100
        let time = Double(trailMakingResult.endDate.timeIntervalSince(trailMakingResult.startDate))
        
        var score = OCKOutcomeValue(perc)
        var sec = OCKOutcomeValue(time)
        score.kind = trailMaking
        sec.kind = trailMakingTime
        
        return [score, sec]
    }
    
    static let memory = "Memory Score"
    
    static func memoryTask() -> ORKTask {
        let memoryTask = ORKOrderedTask.spatialSpanMemoryTask(
            withIdentifier: TaskIDs.memoryTest,
            intendedUseDescription: nil,
            initialSpan: 2,
            minimumSpan: 2,
            maximumSpan: 6,
            playSpeed: TimeInterval(integerLiteral: 1),
            maximumTests: 6,
            maximumConsecutiveFailures: 3,
            customTargetImage: nil,
            customTargetPluralName: nil,
            requireReversal: false,
            options: [])
        
        return memoryTask
    }
    
    static func extractMemoryOutcome(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
        
        guard let memoryResult = result.results?
            .compactMap({ $0 as? ORKStepResult })
            .compactMap({ $0.results })
            .flatMap({ $0 })
            .compactMap({ $0 as? ORKSpatialSpanMemoryResult })
            .first else {

            assertionFailure("Failed to parse range of motion result")
            return nil
        }
        
        var score = OCKOutcomeValue(Double(memoryResult.score))
        score.kind = memory
        
        return [score]
    }
}

