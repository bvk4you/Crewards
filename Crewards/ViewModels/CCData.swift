//
//  CCData.swift
//  Crewards
//
//  Created by vabhaske on 21/07/20.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

class CCData: ObservableObject{
    let db  = Firestore.firestore()
   // @Published var crewards: CrewardsModel?
    @Published var cards:[Card]
    @Published var sortFilterData:SortFilterModel?
    @Published var sortFilterState = SortFilterState()
    init() {
        cards = []
    }
    func getEmptyCard()->Card{
    return Card(
        title: "",id: -1,gracePeriod: "20-50", bank: "", interestPerMonth: 3.35,creditLimit: 0,

              partners: [],
              contactLess: true,
              eligibility: Eligibility(income: 0, ITR: 0, description: "N/A"),
              brand: ["visa","master"],
              categories: [],
              tier: [],
              fees: Fees(joiningFees: 2999, renewalFees: 2999, welcomeRewards: WelcomeRewards(cashback: 0, points: 0, pointsValueinINR: 0, description: ""), waiverCondition: "Joining/Renewal Fee: Rs.2,999+Tax (Renewal Fee Waived on 3 Lakh spend)"),

              foreignTransactions: ForeignTransactions(markupFees: 3.5, rewardRate: 0.5),
              insurance: Insurance(creditShield: 100000, airDeath: 5000000, medicalAbroad: 0),
              rewards: RewardRate(entertainment:2.5, grocery: 2.5, shopping: 0, food: 2.5, travel: 0, others: 0.5,minRate:5.0,maxRate:0.5,utilityBills:5,expiryTime:0),

              benefits: Benefits(
                   vouchers:[],
                      loungeAccess:LoungeAccess(domesticAirports: LoungeDetails(charges: 0, freeVisitsPerQuarter: 2, freeVisitsPerYear: 8, unlimited: false, supplementaryBenefit: false, condtions: "Offer is valid for Primary Cardholders only",programOffering: "VISA/Mastercard"),
                          internationalAirports:[] )),
              highlightedColor: BrandColor(r: 1, g: 1, b: 1, alpha: 1.0),
              shadowColor: BrandColor(r:0.5,g:0.5,b:0.5,alpha: 1.0),
              gradientColor:[BrandColor(r: 0.149, g: 0.247, b: 0.623, alpha: 1.0),
                             BrandColor(r: 0.682, g: 0.301, b: 1, alpha: 1.0)]
              
              )
    }
    
   func addNewCards()
   {
        SBIPrime().create()
        HDFCInfinia().create()
        HDFCRegalia().create()
        ICICIEmeralde().create()
    
    CitiPremierMiles().create()
    HDFCDinersBlack().create()
    HSBCPlatinum().create()
    SBIElite().create()
    }
    func load()
    {
        
//        let cardsRef = db.collection("Cards")
//                         .whereField("categories", arrayContainsAny: ["shopping","insurance"])
//           // .order(by: "id")
//
//        cardsRef.getDocuments(){ (querySnapshot, err) in
//            guard let documents = querySnapshot?.documents else {
//              print("No documents")
//              return
//            }
//            for document in querySnapshot!.documents {
//                           print("\(document.documentID) => \(document.data())")
//
//                       }
//             self.cards = documents.compactMap { queryDocumentSnapshot -> Card? in
//                          return try? queryDocumentSnapshot.data(as: Card.self)
//                        }
//
//        }
        

        db.collection("Cards").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            for document in querySnapshot!.documents {
                           print("\(document.documentID) => \(document.data())")

                       }
            self.cards = documents.compactMap { queryDocumentSnapshot -> Card? in
              return try? queryDocumentSnapshot.data(as: Card.self)
            }


        }
        
    }
    fileprivate func baseQuery() -> Query {
      return Firestore.firestore().collection("Cards")
    }

    
    func loadWithFilter(filter:SortFilterState)
    {
        var filtered = baseQuery()
        if(filter.categoryOptions.count > 0) {
            filtered = filtered.whereField("categories", arrayContainsAny: filter.categoryOptions)
        }
        if(filter.sortOn != nil) {
        filtered = filtered.order(by: filter.sortOn)
        }

               filtered.getDocuments(){ (querySnapshot, err) in
                   guard let documents = querySnapshot?.documents else {
                     print("No documents")
                     return
                   }
                   for document in querySnapshot!.documents {
                                  print("\(document.documentID) => \(document.data())")

                              }
                    self.cards = documents.compactMap { queryDocumentSnapshot -> Card? in
                                 return try? queryDocumentSnapshot.data(as: Card.self)
                               }

               }
               
        
    }

    func loadSortFilterData()
    {
        db.collection("SortFilterData").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            for document in querySnapshot!.documents {
                           print("\(document.documentID) => \(document.data())")
                
                       }
            let array = documents.compactMap { queryDocumentSnapshot -> SortFilterItem? in
              return try? queryDocumentSnapshot.data(as: SortFilterItem.self)
            }
            self.sortFilterData = SortFilterModel(selectedCategory: array[0], allItems: array)
            print("\(self.sortFilterData )")

           
            
        }
        
    }

    
}
