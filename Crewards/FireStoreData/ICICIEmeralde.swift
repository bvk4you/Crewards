//
//  ICICIEmeralde.swift
//  Crewards
//
//  Created by vabhaske on 03/08/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct ICICIEmeralde {
    let db  = Firestore.firestore()

    func create()->Void{
            var newCard = Card(
                title: "Emeralde",id: 4,gracePeriod: "20-50", bank: "ICICI", interestPerMonth: 2.99,creditLimit: 0,

                      partners: [],
                      contactLess: true,
                      eligibility: Eligibility(income: 0, ITR: 0, description: "N/A"),
                      brand: ["visa","master"],
                      categories: [CardCategory.shopping,CardCategory.flights,CardCategory.hotels,CardCategory.insurance],
                      tier: ["premium"],
                      fees: Fees(joiningFees: 2999, renewalFees: 2999, welcomeRewards: WelcomeRewards(cashback: 0, points: 0, pointsValueinINR: 0, description: ""), waiverCondition: "Joining/Renewal Fee: Rs.2,999+Tax (Renewal Fee Waived on 3 Lakh spend)"),

                      foreignTransactions: ForeignTransactions(markupFees: 3.5, rewardRate: 0.5),
                      insurance: Insurance(creditShield: 100000, airDeath: 5000000, medicalAbroad: 0),
                      rewards: RewardRate(entertainment:2.5, grocery: 2.5, shopping: 0, food: 2.5, travel: 0, others: 0.5,minRate:5.0,maxRate:0.5,utilityBills:5,expiryTime:0),

                      benefits:[BenefitsCategory.vouchers],
                benefitsDetails: Benefits(                           vouchers:[Voucher(brand: "Welcome Gift", description: "Welcome e-gift Voucher worth Rs. 3,000 from any of the following brands: Bata/Hush Puppies, Pantaloons, Aditya Birla Fashion, Shoppers Stop and Yatra.com", value:3000.0,isMilestoneLinked: false),
                                     Voucher(brand: "Yatra/Pantaloons", description: "E-Gift Voucher worth Rs. 7,000 from Yatra.com/Pantaloons on achieving annual spends of Rs. 5 Lakhs", value: 7000, isMilestoneLinked: true),
                                     Voucher(brand:"Trident Privilege Membership",description: "Enjoy complimentary Trident Privilege Red Tier Membership\\nGet exclusive 1,000 Welcome Points on registration",value: 0,isMilestoneLinked: false),
                                     Voucher(brand:"Club Visatara Membership", description: "Enjoy Complimentary Club Vistara Silver membership", value: 0, isMilestoneLinked: false),
                                     Voucher(brand:"Pizza Hut",description: "Get Pizza Hut e-Voucher worth Rs. 1,000 on achieving spends of Rs. 50,000 in a calendar quarter",value:1000.0,isMilestoneLinked: true)],
                              loungeAccess:LoungeAccess(domesticAirports: LoungeDetails(charges: 0, freeVisitsPerQuarter: 2, freeVisitsPerYear: 8, unlimited: false, supplementaryBenefit: false, condtions: "Offer is valid for Primary Cardholders only",programOffering: "VISA/Mastercard"),
                                  internationalAirports: [
                                      LoungeDetails(charges: 28, freeVisitsPerQuarter: 2, freeVisitsPerYear: 4, unlimited: false, supplementaryBenefit: false, condtions: "Offer is valid for Primary Cardholders only",programOffering: "Priority Pass")])),
                      highlightedColor: BrandColor(r: 1, g: 1, b: 1, alpha: 1.0),
                      shadowColor: BrandColor(r:0.5,g:0.5,b:0.5,alpha: 1.0),
                      gradientColor:[BrandColor(r: 0.623, g: 0.247, b: 0.149, alpha: 1.0),
                        BrandColor(r: 1.0, g: 0.301, b: 1, alpha: 0.682)]
                      
                      )
        let newCityRef = db.collection("Cards").document("ICICI Emeralde")
        try?newCityRef.setData(from:newCard)

    }
}
