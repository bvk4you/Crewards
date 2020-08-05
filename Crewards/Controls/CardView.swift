//
//  CardView.swift
//  Crewards
//
//  Created by vabhaske on 24/07/20.
//

import SwiftUI

struct CardView: View {
    
    var card: Card
    var geometry: GeometryProxy
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
                Group {
                    HStack(alignment: .top, spacing:20) {
                        Spacer()
                        self.cardLogo(for: geometry)
                    }.padding(EdgeInsets(top:10,leading:0,bottom:geometry.size.width * 0.46 - 50,trailing:5))
                    HStack {
                        self.title
                        Spacer()
                    }.padding([.leading, .bottom],5)
                    
                }.shadow(color:self.getRGBColor(col: card.highlightedColor!), radius: 5, x: 0, y: 0)
            }
            .skeleton(with: card.id == -1)
            .shape(type: .rectangle)
            .animation(type: .linear())

            .frame(width:geometry.size.width-100,
                    height:geometry.size.width * 0.46)
                .background(LinearGradient(gradient: self.getGradient(colors:card.gradientColor),
                                           startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 0)))
                .cornerRadius(5)
                .shadow(radius: 10)

            
        }
}

// MARK: Subviews

extension CardView {
    
    func getGradient(colors:[BrandColor]?) -> Gradient {
        return Gradient(colors: [
            Color(.sRGB, red: colors![0].r, green: colors![0].g, blue: colors![0].b, opacity: colors![0].alpha),
            Color(.sRGB, red: colors![1].r , green: colors![1].g, blue: colors![1].b , opacity: colors![0].alpha)])
        
    }

    var title: some View {
           VStack(alignment: .leading, spacing: 3) {
               Group {
                Text(self.card.title!).font(.system(size: 14,weight:.semibold)).padding(.all, 0.0)
               }
               .foregroundColor(self.getRGBColor(col:card.highlightedColor!))
           }
       }
    
    func getRGBColor(col:BrandColor) -> Color
    {
        return Color(.sRGB, red: col.r, green: col.g, blue: col.b, opacity: col.alpha)
    }

    var expiration: some View {
        VStack(alignment: .center, spacing: 3) {
            Group {
                Text("Expiry ").font(.system(size: 8))
                Text("08/25").font(.system(size: 12))
            }
            .foregroundColor(self.getRGBColor(col:card.highlightedColor!))
        }
    }
    
    func cardLogo(for geometry: GeometryProxy) -> some View {
        Image(card.bank!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            //.frame(height: 20,alignment: .top)
    }
    
    var cardHolderName: some View {
        Text("FIRST NAME LAST NAME")
            .foregroundColor(self.getRGBColor(col:card.highlightedColor!))
            .minimumScaleFactor(2)
            .font(.system(size: 10))
            .shadow(radius: 3)
            .padding(.horizontal)
    }
    
    var cardNumber: some View {
        Text("4567    XXXX    XXXX    1234")
            .foregroundColor(self.getRGBColor(col:card.highlightedColor!))
            .font(.system(size: 16, weight: .medium))
    }
    
    func chip(for geometry: GeometryProxy) -> some View {
        Image("chip")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: geometry.size.height / 12)
            .fixedSize()
    }
    
    func contactLess(for geometry: GeometryProxy) -> some View {
        Image(systemName: "radiowaves.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.height / 30)
            .foregroundColor(self.getRGBColor(col:card.highlightedColor!))
            .fixedSize()
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
        //ForEach(["iPhone SE", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) {
            CardView(card:  Card(
               title: "SBI Prime",id: 1,gracePeriod: "20-50", bank: "SBI", interestPerMonth: 3.35,creditLimit: 0,

                     partners: [],
                     contactLess: true,
                     eligibility: Eligibility(income: 0, ITR: 0, description: "N/A"),
                     brand: ["visa","master"],
                     categories: [CardCategory.shopping,CardCategory.flights,CardCategory.hotels],
                     tier: ["premium"],
                     fees: Fees(joiningFees: 2999, renewalFees: 2999, welcomeRewards: WelcomeRewards(cashback: 0, points: 0, pointsValueinINR: 0, description: ""), waiverCondition: "Joining/Renewal Fee: Rs.2,999+Tax (Renewal Fee Waived on 3 Lakh spend)"),

                     foreignTransactions: ForeignTransactions(markupFees: 3.5, rewardRate: 0.5),
                     insurance: Insurance(creditShield: 100000, airDeath: 5000000, medicalAbroad: 0),
                     rewards: RewardRate(entertainment:2.5, grocery: 2.5, shopping: 0, food: 2.5, travel: 0, others: 0.5,minRate:5.0,maxRate:0.5,utilityBills:5,expiryTime:0),

                     benefits: Benefits(
                          vouchers:[Voucher(brand: "Welcome Gift", description: "Welcome e-gift Voucher worth Rs. 3,000 from any of the following brands: Bata/Hush Puppies, Pantaloons, Aditya Birla Fashion, Shoppers Stop and Yatra.com", value:3000.0,isMilestoneLinked: false),
                                    Voucher(brand: "Yatra/Pantaloons", description: "E-Gift Voucher worth Rs. 7,000 from Yatra.com/Pantaloons on achieving annual spends of Rs. 5 Lakhs", value: 7000, isMilestoneLinked: true),
                                    Voucher(brand:"Trident Privilege Membership",description: "Enjoy complimentary Trident Privilege Red Tier Membership\\nGet exclusive 1,000 Welcome Points on registration",value: 0,isMilestoneLinked: false),
                                    Voucher(brand:"Club Visatara Membership", description: "Enjoy Complimentary Club Vistara Silver membership", value: 0, isMilestoneLinked: false),
                                    Voucher(brand:"Pizza Hut",description: "Get Pizza Hut e-Voucher worth Rs. 1,000 on achieving spends of Rs. 50,000 in a calendar quarter",value:1000.0,isMilestoneLinked: true)],
                             loungeAccess:LoungeAccess(domesticAirports: LoungeDetails(charges: 0, freeVisitsPerQuarter: 2, freeVisitsPerYear: 8, unlimited: false, supplementaryBenefit: false, condtions: "Offer is valid for Primary Cardholders only",programOffering: "VISA/Mastercard"),
                                 internationalAirports: [
                                     LoungeDetails(charges: 28, freeVisitsPerQuarter: 2, freeVisitsPerYear: 4, unlimited: false, supplementaryBenefit: false, condtions: "Offer is valid for Primary Cardholders only",programOffering: "Priority Pass")])),
                     highlightedColor: BrandColor(r: 1, g: 1, b: 1, alpha: 1.0),
                     shadowColor: BrandColor(r:0.5,g:0.5,b:0.5,alpha: 1.0),
                     gradientColor:[BrandColor(r: 0.149, g: 0.247, b: 0.623, alpha: 1.0),
                                    BrandColor(r: 0.682, g: 0.301, b: 1, alpha: 1.0)]
                     
                     )
                ,geometry: geo)
                .padding(32)
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
       // }
    }
}
