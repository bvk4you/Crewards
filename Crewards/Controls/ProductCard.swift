//
//  ProductCard.swift
//  ProductCard
//
import SwiftUI
import Combine
import SkeletonUI
struct ProductCard: View {
    var card:Card?
    var geometry: GeometryProxy
    var buttonHandler: (()->())?
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            CardView(card:self.card ?? CCData().getEmptyCard(),geometry: geometry)
                .padding(.top,10)
            
            // Stack bottom half of card
            VStack(alignment: .leading, spacing: 6) {
                Text(self.card?.title)
                    .fontWeight(Font.Weight.heavy)
                    .skeleton(with: self.card?.id! == -1)
                    .shape(type: .rectangle)
                    .animation(type: .linear())
                
                Text(self.card?.benefits?.vouchers?.isEmpty ?? false ? "" : self.card?.benefits?.vouchers?[2]?.description?.replacingOccurrences(of: "\\n", with: "\n"))
                    .font(Font.custom("HelveticaNeue-Bold", size: 10))
                    .foregroundColor(Color.gray)
                    .skeleton(with: self.card?.id! == -1)
                    .shape(type: .rectangle)
                     .multiline(lines: 2, scales: [1: 0.5])
                    .animation(type: .linear())
                
                // 'Based on:' Horizontal Category Stack
                HStack(alignment: .center, spacing: 6) {
                    Text("Benefits on:")
                        .font(Font.system(size: 12))
                        .fontWeight(Font.Weight.medium)
                        HStack {
                        ForEach(self.card?.categories ?? [],id :\.self){ category  in
                            Image(uiImage: UIImage(systemName:category.iconName)?.withRenderingMode(.alwaysTemplate))
                                .foregroundColor(category.iconColor)
                            
                            
                        }
                    }
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 0) {
                        Text("Vouchers:")
                            .font(Font.system(size: 12))
                            .fontWeight(Font.Weight.medium)
                            .skeleton(with: self.card?.id! == -1)
                            .shape(type: .rectangle)
                            .animation(type: .linear())

                        Text("\(self.card!.categories!.count)")
                            .font(Font.custom("HelveticaNeue", size: 14))
                            .skeleton(with: self.card?.id! == -1)
                            .shape(type: .rectangle)
                            .animation(type: .linear())
                    }
                }
                .padding([.top, .bottom], 8)
                .skeleton(with: self.card?.id! == -1)
                .shape(type: .rectangle)
                .animation(type: .linear())
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: nil, height: 1, alignment: .center)
                    .padding([.leading, .trailing], -12)
                
                // Price and Buy Now Stack
                HStack(alignment: .center, spacing: 4) {
                    Text(String(format:"%.2f",self.card?.interestPerMonth as! CVarArg))
                        .fontWeight(Font.Weight.heavy)
                    Text("% per month")
                        .font(Font.system(size: 13))
                        .fontWeight(Font.Weight.bold)
                        .foregroundColor(Color.gray)
                    Spacer()
                    
                    Text("BUY NOW")
                        .fontWeight(Font.Weight.heavy)
                        .foregroundColor(Color(red: 231/255, green: 119/255, blue: 112/255))
                        .onTapGesture {
                            self.buttonHandler?()
                    }
                    
                }.padding([.top, .bottom], 8)
                    .skeleton(with: self.card?.id! == -1)
                    .shape(type: .rectangle)
                    .animation(type: .linear())
                
                
            }
            .padding(12)
        }.onAppear(){
            print("card on appear , tile \(self.card?.title)")
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        
    }
}

//struct ProductCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCard(card: nil, buttonHandler: nil)
//    }
//}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)
        
        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        return path
    }
}
