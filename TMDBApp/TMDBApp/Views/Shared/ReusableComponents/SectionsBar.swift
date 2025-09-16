//
//  SectionsBar.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct SectionsBar<Section: Hashable & CaseIterable>: View {
    @Binding var selectedSection: Section
    let titles: (Section) -> String
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.large) {
                ForEach(Array(Section.allCases), id: \.self) { section in
                    VStack(alignment: .center) {
                        Button {
                            selectedSection = section
                        } label: {
                            Text(titles(section))
                                .font(AppTheme.Typography.subtitle)
                                .foregroundStyle(.black)
                                .fontWeight(selectedSection == section ? .bold : .thin)
                        }
                        if selectedSection == section {
                            Rectangle()
                                .frame(height: 4)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.vertical)
        }
    }
}
