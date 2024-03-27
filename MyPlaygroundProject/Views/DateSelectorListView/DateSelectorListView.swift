//
//  DateSelectorListView.swift
//  MyPlaygroundProject
//
//  Created by 山口誠士 on 2024/03/27.
//

import SwiftUI

enum Weekday: Int {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case none

    var string: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        case .none: return ""
        }
    }
}

struct DateSelectorModel:Equatable, Identifiable {

    enum Capacity: String {
        case full
        case half
        case empty
        case none

        static var random: Capacity {
            switch Int.random(in: 1...3) {
            case 1: return .full
            case 2: return .half
            case 3: return .empty
            default: return .none
            }
        }
    }

    let year: String
    let month: String
    let date: String
    let weekDay: Weekday
    let isFirstDate: Bool
    let capacity: Capacity

    var id: String {
        return "\(year)-\(month)-\(date)-\(weekDay.string)"
    }

    var fontColor: Color {
        switch weekDay {
        case .sunday:
            return .red
        case .saturday:
            return .blue
        default:
            return .black
        }
    }

    var capacityImage: Image? {
        switch capacity {
        case .full: return .init("fullCapacity", bundle: .main)
        case .half: return .init("halfCapacity", bundle: .main)
        case .empty: return .init("emptyCapacity", bundle: .main)
        case .none: return nil
        }
    }

    var dateString: String {
        isFirstDate ? "\(month)/\(date)" : date
    }

    static var mockList: [DateSelectorModel] {
        return [Int](1...20).map { i in
            return .init(
                year: "2024",
                month: "12",
                date: "\(i)",
                weekDay: .init(rawValue: i % 7) ?? .none,
                isFirstDate: i == 1,
                capacity: .random
            )
        }
    }
}

struct DateSelectorListView: View {

    private let models: [DateSelectorModel]

    init(models: [DateSelectorModel]) {
        self.models = models
    }

    private func isLast(_ model: DateSelectorModel) -> Bool {
        model == models.last
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0, content: {
                ForEach(models) { model in
                    DateSelectorView(model: model)
                    .overlay (
                        GeometryReader(content: { geometry in
                            Path { path in
                                let x = geometry.size.width
                                path.addLines([
                                    .init(x: x, y: 0),
                                    .init(x: x, y: geometry.size.height)
                                ])
                            }
                            .stroke(
                                Color.gray,
                                lineWidth: 0.2
                            )
                            .opacity(isLast(model) ? 0 : 1)
                        })
                    )
                }
            })
        }
    }
}


struct DateSelectorView: View {

    private let model: DateSelectorModel

    init(model: DateSelectorModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: 0, content: {
            VStack(spacing: 2, content: {
                Text(model.dateString)
                    .font(.system(size: 12, weight: .semibold))

                Text(model.weekDay.string)
                    .font(.system(size: 11, weight: .regular))
            })
            .foregroundColor(model.fontColor)
            .padding(.vertical, 4)

            Divider()

            if let image = model.capacityImage {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .padding(.vertical, 12)
            }

            Divider()
        })
        .frame(width: 46)
    }
}

#Preview {
    DateSelectorListView(
        models: DateSelectorModel.mockList
//        models: []
    )
}
