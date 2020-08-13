//
//  CardModels.swift
//  Crewards
//
//  Created by vabhaske on 30/07/20.
//

import Foundation
import SwiftUI
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let crewards = try? newJSONDecoder().decode(Crewards.self, from: jsonData)


// MARK: - Crewards
struct CrewardsModel: Codable {
    let cards: [Card]?

    enum CodingKeys: String, CodingKey {
        case cards = "Cards"
    }
}

// MARK: - Card
struct Card: Codable, Identifiable,Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    let title: String?
    let id: Int?
    let gracePeriod: String?
    let bank: String?
    let interestPerMonth: Double?
    let creditLimit: Int?
    let partners: [String]?
    let contactLess:Bool?

    let eligibility: Eligibility?
    let brand: [String]?
    let categories: [CardCategory]?
    let tier: [String]?

    let fees: Fees?
    let cashAdvance:CashAdvance?
    let foreignTransactions: ForeignTransactions?
    let insurance: Insurance?

    let rewards: RewardRate?

    let benefits: [BenefitsCategory]?
    let benefitsDetails: Benefits?
    
    let highlightedColor:BrandColor?
    let shadowColor:BrandColor?
    let gradientColor:[BrandColor]?
    
    enum CodingKeys: String, CodingKey {
        case eligibility, partners, gracePeriod, bank, interestPerMonth
        case benefits, title, categories, tier, creditLimit, foreignTransactions, insurance, rewards, fees, brand,id
        case highlightedColor,shadowColor,gradientColor,contactLess, benefitsDetails,cashAdvance
    }
}

enum BenefitsCategory : String,Codable,CaseIterable,Equatable {
    case vouchers = "vouchers"
    case memberhips = "memberships"
    case loungeacess = "Lounge Access"
        enum CodingKeys {
        case vouchers,memberhips,loungeacess
    }
}
enum CardCategory : String,Codable,CaseIterable,Equatable {
    case grocery = "grocery"
    case hotels = "hotels"
    case shopping = "shopping"
    case flights = "flights"
    case gifts = "gifts"
    case insurance = "insurance"
    enum CodingKeys {
        case grocery,hotels,shopping,flights,gifts,insurance
    }
}

extension CardCategory {
var iconName: String {
    switch self {
    case .grocery:
        return "cart.fill"
    case .hotels:
        return "bed.double.fill"
    case .shopping:
        return "bag.fill"
    case .flights:
        return "airplane"
    case .gifts:
        return "gift.fill"
    case .insurance:
        return "checkmark.shield.fill"
    }
 }
    var iconColor: Color {
       switch self {
       case .grocery:
        return Color.yellow
       case .hotels:
        return Color.red
       case .shopping:
        return Color.orange
       case .flights:
        return Color.blue
       case .gifts:
        return Color.red
       case .insurance:
        return Color.purple
       }
    }

}
struct BrandColor:Codable {
    var r:Double
    var g:Double
    var b:Double
    var alpha:Double
}


// MARK: - Eligibility
struct Eligibility: Codable,Equatable {
    let income, ITR: Int?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case income
        case ITR
        case description
    }
}

// MARK: - Eligibility
struct CashAdvance: Codable,Equatable {
    let limit:String?
    let freeCreditPeriod: String?
    let financeCharges:Double?
    let financeChargeDetails:String?
    let fees:Double?
    let feesDetails:String?
    let internationATMS:String?

}




// MARK: - WelcomeRewards
struct WelcomeRewards: Codable,Equatable {
    let cashback, points, pointsValueinINR: Int?
    let description: String?
}

// MARK: - Fees
struct Fees: Codable,Equatable {
    let joiningFees: Int?
    let renewalFees: Int?
    let welcomeRewards: WelcomeRewards?
    let waiverCondition: String?
}

// MARK: - ForeignTransactions
struct ForeignTransactions: Codable,Equatable {
    let markupFees, rewardRate: Double?
}

// MARK: - Insurance
struct Insurance: Codable,Equatable {
    let creditShield, airDeath, medicalAbroad: Int?
}

// MARK: - Rewards
struct RewardRate: Codable,Equatable {
  let entertainment, grocery, shopping : Double?
  let food, travel, others: Double?
  let minRate,maxRate:Double?
    let utilityBills:Double?
  let expiryTime:Int?
}



// MARK: - Voucher
struct Voucher: Codable,Equatable {
    let brand: String?
    let description: String?
    let value:Double?
    let isMilestoneLinked:Bool?
}

// MARK: - Benefits
struct Benefits: Codable,Equatable {
    let vouchers: [Voucher?]?
    let loungeAccess: LoungeAccess?
}

// MARK: - LoungeAccess
struct LoungeAccess: Codable,Equatable {
    let domesticAirports: LoungeDetails?
    let internationalAirports: [LoungeDetails]?
}

// MARK: - DomesticAirports
struct LoungeDetails: Codable,Equatable {
    let charges, freeVisitsPerQuarter, freeVisitsPerYear: Int?
    let unlimited, supplementaryBenefit: Bool?
    let condtions:String?
    let programOffering: String?
}












