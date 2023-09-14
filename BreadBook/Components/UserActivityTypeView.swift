//
//  UserActivityTypeView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct UserActivityTypeView: View {
    var activityLogType: String
    var activityLogTime: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(activityLogType)
                .font(.button1)
                .foregroundColor(Color.originalBlack)
            
            Spacer()
            
            Text(Date(timeIntervalSince1970: activityLogTime.convertToTimeInterval()).timeAgoDisplay())
                .font(BreadBookFont.createFont(weight: .regular, size: 10))
                .foregroundColor(Color.neutral600)
            
        }
        .padding(.horizontal, 20)
    }
}

struct UserActivityTypeView_Previews: PreviewProvider {
    static var previews: some View {
        UserActivityTypeView(activityLogType: "You Commented on this post",
                             activityLogTime: "1683097603")
    }
}

enum ActivityUser: Equatable {
    case me
    case user(String)
    
    func getActivityType(type: UserActivityType) -> String {
        switch type {
        case .empty, .creation:
            return ""
        case .comment:
            switch self {
            case .me:
                return "You commented on this"
            case .user(let userName):
                return "\(userName) commented on this"
            }
        case .reaction:
            switch self {
            case .me:
                return "You liked this"
            case .user(let userName):
                return "\(userName) liked this"
            }
        }
    }
}

class ActivityUserWrapper {
    static var shared = ActivityUserWrapper()
    
    var activityUser: ActivityUser = .me
}
