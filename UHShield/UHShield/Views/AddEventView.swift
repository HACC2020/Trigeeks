//
//  AddEventView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import CoreImage.CIFilterBuiltins
import SwiftUI



struct AddEventView: View {
    @ObservedObject var eventViewModel = EventViewModel()
    
    @State private var name = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var location = ""
    @State private var sponsor = ""
    @Binding var isShowAddEventView: Bool
    
    @State var event = Event(sponsor: "Wei", guests: ["John", "He"], arrivedGuests: [], location: Location(building: "A", roomID: 302), date: Date(), startTime: Date(), endTime: Date())
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        NavigationView {
            Form {
                
                TextField("name:", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                
                DatePicker("Date", selection: $date, in: Date()..., displayedComponents: .date).padding(.horizontal).datePickerStyle(CompactDatePickerStyle())
                
                DatePicker("Start Time", selection: $startTime, in: date..., displayedComponents: .hourAndMinute).padding(.horizontal)
                
                DatePicker("End Time", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute).padding(.horizontal)
                
                TextField("location:", text: $location)
                    .textContentType(.location)
                    .font(.title)
                    .padding(.horizontal)
                TextField("sponsor:", text: $sponsor)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                
                Text("Date is \(date)\n \(startTime) \n\(endTime)")
                
                Text("\(eventViewModel.events.count)")
                
                Image(uiImage: generateQRCode(from: "\(name)\n\(date)\n\(location)\n\(sponsor)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                
            }.navigationBarItems(leading: Button(action: {handleBackButton()}, label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }.font(.system(size: 20))
            }))
            .navigationBarItems(trailing: Button(action: {
                eventViewModel.addEvent(event: event)
            }, label: {
                Text("Done")
            }))
        }.onAppear {
            eventViewModel.fetchData()
        }
    }
    
    func handleBackButton() {
        withAnimation(.linear) {
            isShowAddEventView = false
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
        AddEventView(isShowAddEventView: .constant(true))
    }
}
