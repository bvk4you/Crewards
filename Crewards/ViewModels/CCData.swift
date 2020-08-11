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

extension CCData{
    enum State : Equatable {
        case idle
        case requestedFetch
        case fetchRequestFailed
        case fetchRequestSucceededWithData
        case fetchRequestSucceededWithNoResults
    }

}

class CCData: ObservableObject{
    let db  = Firestore.firestore()
   // @Published var crewards: CrewardsModel?
     var cards:[Card]
    var originalCards:[Card]

    @Published var sortFilterData:SortFilterModel?
    @Published var sortFilterState = SortFilterState()
    @Published private(set) var state = State.idle
    init() {
        cards = []
        originalCards = []
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
              benefits: [],
              benefitsDetails: Benefits(
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
        var filter = SortFilterState()
        self.loadWithFilter(filter:filter)
        
    }
    fileprivate func baseQuery() -> Query {
      return Firestore.firestore().collection("Cards")
    }
//    func getSortFilterState() -> SortFilterState
//    {
//        return self._sortFilterState
//    }
    func isFilterApplied() -> Bool
    {
        if self.sortFilterState.sortOn != "id" {
            return true
        }
        if self.sortFilterState.categoryOptions.count > 0 {
            return true
        }
        if(self.sortFilterState.benefitsOptions.count > 0){
            return true
        }
        return false
    }

    func resetSortFilterState(filter:SortFilterState)
    {
        self.sortFilterState = filter
    }
    
    func loadFromLocalData(filter:SortFilterState)
    {
        var cards = self.originalCards
        self.cards = []
        self.sortFilterState = filter

        if filter.categoryOptions.count > 0
        {
                cards = cards.filter(
                    {
                        let arr = $0.categories!.map { $0 }
                        
                        let listSet = Set(arr)
                        let findListSet = Set( filter.categoryOptions)

                     let newset =  listSet.intersection(findListSet)
                        
                        return !newset.isEmpty
                
                    }
                )
        }
        
        if filter.benefitsOptions.count > 0
        {
                cards = cards.filter(
                    {
                        let arr = $0.benefits!.map { $0 }
                        
                        let listSet = Set(arr)
                        let findListSet = Set( filter.benefitsOptions)

                     let newset =  listSet.intersection(findListSet)
                        
                        return !newset.isEmpty
                
                    }
                )
        }

        switch(filter.sortOn)
        {
        case "interestPerMonth":
            cards = cards.sorted(by: {$0.interestPerMonth! < $1.interestPerMonth!})
            
        case "bank":
            cards = cards.sorted(by: {$0.bank! < $1.bank!})
        
        default:
            cards = cards.sorted(by: {$0.id! < $1.id!})

        }
        self.cards = cards
        
        

        self.state = self.cards.count == 0 ? .fetchRequestSucceededWithNoResults : .fetchRequestSucceededWithData

                    

    }
    
    func loadWithFilter(filter:SortFilterState)
    {
        
        if(filter.source != "local")
        {
        
        var filtered = baseQuery()
        if(filter.categoryOptions.count > 0) {
            filtered = filtered.whereField("categories", arrayContainsAny: filter.categoryOptions)
        }
        if(filter.benefitsOptions.count > 0)
        {
            filtered = filtered.whereField("benefits", arrayContainsAny: filter.benefitsOptions)

        }
        if(filter.sortOn != nil) {
        filtered = filtered.order(by: filter.sortOn)
        }

        self.cards = []
        self.sortFilterState = filter
               filtered.getDocuments(){ (querySnapshot, err) in

                if err != nil {
                    self.state = .fetchRequestFailed
                    return
                }
                   guard let documents = querySnapshot?.documents else {
                     print("Request failed")
                    self.state = .fetchRequestFailed
                     return
                   }
                if querySnapshot?.documents.count ?? 0 <= 0 {
                    print("No documents")
                    self.state = .fetchRequestSucceededWithNoResults
                    return

                }
                   for document in querySnapshot!.documents {
                                  print("\(document.documentID) => \(document.data())")

                              }

                self.cards =  documents.compactMap { queryDocumentSnapshot -> Card? in
                                 return try? queryDocumentSnapshot.data(as: Card.self)
                               }
                self.originalCards = self.cards
                self.state = .fetchRequestSucceededWithData


               }
        }
        else {
            loadFromLocalData(filter:filter)
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
