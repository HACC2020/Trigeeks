//
//  HomeView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import SwiftUI

struct HomeView: View {
    @Namespace private var animation
    @State var isCardExpand = false
    @State var isShowScanner = false
    @Binding var isShowAddEventView: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 80) {
                
                // Upcoming event card
                if !isCardExpand {
                    HStack {
                        VStack {
                            HStack {
                                Text("Upcoming Event").fontWeight(.semibold).font(.title2).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }.padding()
                            Spacer()
                        }
                    }.frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.2)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0).foregroundColor(Color(#colorLiteral(red: 0.9324335456, green: 0.9474714398, blue: 1, alpha: 1)))
                            .shadow(color: Color(#colorLiteral(red: 0.7676328421, green: 0.7859991193, blue: 0.8326527476, alpha: 1)), radius: 5, x: 0.0, y: 5.0)
                    )
                    .matchedGeometryEffect(id: "eventCard", in: animation)
                    .onTapGesture(count: 1, perform: {
                        withAnimation(.spring()) {
                            self.isCardExpand.toggle()
                        }
                    })
                    .zIndex(2)
                }
                
                Spacer()
                HStack {
                    Image(systemName: "plus.bubble").font(.system(size: 35))
                    Text("Add Event").font(.system(size: 30)).fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .background( RoundedRectangle(cornerRadius: 25.0)
                                .foregroundColor(Color(#colorLiteral(red: 0.7393737435, green: 0.8587907553, blue: 0.9659621119, alpha: 1)))
                                .frame(width: UIScreen.main.bounds.width*0.9, height: 80)
                                .shadow(color: Color(#colorLiteral(red: 0.7798802257, green: 0.7924112678, blue: 0.8005585074, alpha: 1)), radius: 10, x: 5.0, y: 5.0)
                )
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    
                    withAnimation {
                        isShowAddEventView = true
                    }
                })
                
                HStack {
                    Image(systemName: "qrcode.viewfinder").font(.system(size: 35))
                    Text("Quick Scan").font(.system(size: 30)).fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .background( RoundedRectangle(cornerRadius: 25.0)
                                .foregroundColor(Color(#colorLiteral(red: 0.7393737435, green: 0.8587907553, blue: 0.9659621119, alpha: 1)))
                                .frame(width: UIScreen.main.bounds.width*0.9, height: 80)
                                .shadow(color: Color(#colorLiteral(red: 0.7798802257, green: 0.7924112678, blue: 0.8005585074, alpha: 1)), radius: 10, x: 5.0, y: 5.0)
                )
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    
                    withAnimation {
                        isShowScanner = true
                    }
                })
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            
            
            // expand upcoming event card if user clicked
            if isCardExpand {
                HStack {
                    VStack {
                        HStack {
                            Text("Upcoming Event").fontWeight(.semibold).font(.title2).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.isCardExpand.toggle()
                                }
                            }, label: {
                                Image(systemName: "x.circle.fill").font(.title2).foregroundColor(.gray)
                            })
                        }.padding()
                        .padding(.top, 10)
                        Spacer()
                    }
                }.frame(width: UIScreen.main.bounds.width)
                .background(
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 0.9324335456, green: 0.9474714398, blue: 1, alpha: 1)))
                        .shadow(color: Color(#colorLiteral(red: 0.7676328421, green: 0.7859991193, blue: 0.8326527476, alpha: 1)), radius: 5, x: 0.0, y: 5.0)
                )
                .matchedGeometryEffect(id: "eventCard", in: animation)
            }

        }.onDisappear {self.isCardExpand = false}
        .fullScreenCover(isPresented: $isShowScanner, content: {
            ScannerLayoutView(isShowScanner: $isShowScanner)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isShowAddEventView: .constant(false))
    }
}
