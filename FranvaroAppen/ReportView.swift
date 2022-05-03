//
//  ReportView.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2022-05-02.
//  Copyright © 2022 Knut Inge Grosland. All rights reserved.
//

import SwiftUI

struct ReportView: View {
    
    @ObservedObject var viewModel: ReportViewModel
    
    init(viewModel: ReportViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        
        Form {
            
            Toggle(isOn: $viewModel.completeDay) {
                Text("Heldag")
            }
            .tint(Color(uiColor: UIColor.App.blue))
            .padding()


            if viewModel.shouldShowDatePickers {
                DatePicker(NSLocalizedString("Från", comment: ""), selection: $viewModel.fromDate, displayedComponents: viewModel.displayedDateComponents)
                    .font(.system(.body, design: .rounded))
                    .padding()
                
                DatePicker(NSLocalizedString("Till", comment: ""), selection: $viewModel.toDate, displayedComponents: viewModel.displayedDateComponents)
                    .font(.system(.body, design: .rounded))
                    .padding()
            }
            
            
        }
        .background(Color(uiColor: UIColor.App.blue))
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(viewModel: ReportViewModel(reportType: .sickLeave, child: nil))
    }
}
