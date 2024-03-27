//
//  TimeSelectorGridView.swift
//  MyPlaygroundProject
//
//  Created by masashi.yamaguchi on 2024/03/27.
//

import SwiftUI

struct TimeSelectorItemModel: Equatable, Identifiable {
    let time: String
    let id: String

    static var mockList: [TimeSelectorItemModel] {
        (1...24).map {
            if $0 < 10 {
                return .init(
                    time: "0\($0):00",
                    id: "\($0 + 10000)"
                )
            } else {
                return .init(
                    time: "\($0):00",
                    id: "\($0 + 10000)"
                )
            }
        }
    }
}

struct TimeSelectorGridView: View {

    private let models: [TimeSelectorItemModel]
    private let onTapTime: (String) -> Void

    private var columns: [GridItem] {
        let column = GridItem(
            .adaptive(minimum: .infinity, maximum: .infinity),
            spacing: 8
        )
        return Array(repeating: column, count: 4)
    }

    init(
        models: [TimeSelectorItemModel],
        onTapTime: @escaping (String) -> Void
    ) {
        self.models = models
        self.onTapTime = onTapTime
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8, content: {
            ForEach(models) { model in
                Button(action: {
                    onTapTime(model.id)
                }, label: {
                    Text(model.time)
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundColor(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                })
            }
        })
    }
}

struct TimeSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectorGridView(
            models: TimeSelectorItemModel.mockList,
//            models: [],
            onTapTime: { _ in }
        )
    }
}
