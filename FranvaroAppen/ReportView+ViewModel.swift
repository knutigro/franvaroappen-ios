//
//  ReportView+ViewModel.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2022-05-02.
//  Copyright © 2022 Knut Inge Grosland. All rights reserved.
//

import SwiftUI

class ReportViewModel: ObservableObject {
    
    var child: Child?

    enum ReportType {
        case sickLeave
        case absence
    }

    let reportType: ReportType

    @Published var completeDay = true
    @Published var fromDate: Date
    @Published var toDate: Date
    
    var shouldShowDatePickers: Bool {
        switch reportType {
        case .sickLeave:
            return !completeDay
        case .absence:
            return true
        }
    }
    
    var displayedDateComponents: DatePicker.Components {
        switch reportType {
        case .sickLeave:
            return [.hourAndMinute]
        case .absence:
            return completeDay ? [.date] : [.hourAndMinute, .date]
        }
    }
    
    init(reportType: ReportType, child: Child?) {
        
        self.reportType = reportType
        self.child = child

        let fromDate = Date()
        let toDate = Date(timeInterval: 0, since: fromDate)

        self.fromDate = fromDate
        self.toDate = toDate

    }

    
}
