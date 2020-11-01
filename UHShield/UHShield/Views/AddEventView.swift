//
//  AddEventView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import CoreImage.CIFilterBuiltins
import SwiftUI



struct AddEventView: View {
    @StateObject var eventViewModel = EventViewModel()
    
    @State private var sponsor = ""
    @State private var guests: [String] = []
    @State private var building = ""
    @State private var room = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    // selection of View: AddEvent=21, sponsor=20
    @Binding var selection: Int
    
    @State var event = Event(sponsor: "", guests: [], arrivedGuests: [], location: Location(building: "", roomID: ""), date: Date(), startTime: Date(), endTime: Date())
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Add")
                Form {
           
                    TextField("sponsor(should auto get):", text: $sponsor)
                        .textContentType(.name)
                        .padding(.horizontal)
                    
                    TextField("guests:", text: $sponsor)
                        .textContentType(.name)
                        .padding(.horizontal)

                    TextField("Building:", text: $building)
                        .textContentType(.location)
                        .padding(.horizontal)
                    TextField("Room:", text: $room)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                    
                    
                    
                    
                    DatePicker("Date", selection: $date, in: Date()..., displayedComponents: .date).padding(.horizontal).datePickerStyle(CompactDatePickerStyle())
                    
                    DatePicker("Start Time", selection: $startTime, in: date..., displayedComponents: .hourAndMinute).padding(.horizontal)
                    
                    DatePicker("End Time", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute).padding(.horizontal)
                    
                    Image(uiImage: generateQRCode(from: "\n\(date)\n\(guests)\n\(sponsor)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    
                }.onAppear {
                    eventViewModel.fetchData()
                }
                .navigationBarItems(leading: Button(action: {handleBackButton()}, label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }.font(.system(size: 20))
                }), trailing: Button(action: {
                    eventViewModel.addEvent(event: event)
                }, label: {
                    Text("Done")
            }))
            }
            
        }
    }
    
    func handleBackButton() {
        withAnimation(.linear) {
            selection = 20
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "InputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(selection: .constant(21))
    }
}
