//
//  Modifiers.swift
//  UHShield
//
//  Created by weirong he on 10/28/20.
//

import SwiftUI

struct Modifiers: View {
    var body: some View {
        VStack {
            Button(action: {}, label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
            })
            .buttonStyle(RedLongButtonStyle())
        }
    }
}

struct Modifiers_Previews: PreviewProvider {
    static var previews: some View {
        Modifiers()
    }
}

struct TextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 4)
                            .foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .blur(radius: 4)
                            .offset(x: 2, y: 4)
                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                        
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 4)
                            .foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .blur(radius: 4)
                            .offset(x: -2, y: -3)
                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)))

                    )
            )
    }
    
    
}


struct SectionModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            )
    }
    
    
}

struct LongButtonStyle: ButtonStyle {
    var buttonColor = Color("bg1")
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 15).fill(buttonColor)
                        .shadow(color: Color(#colorLiteral(red: 0.2986346781, green: 0.2874504924, blue: 0.3008843064, alpha: 1)), radius: 5, x: 0, y: 0)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: 5, y: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 15).foregroundColor(buttonColor)
                            .shadow(color: Color(#colorLiteral(red: 0.4459395409, green: 0.4322124422, blue: 0.4563130736, alpha: 1)), radius: 3, x: 2, y: 3)
                            .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
                    }
                }
            )
    }
}

struct RedLongButtonStyle: ButtonStyle {
    var buttonColor = Color("button2")
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 15).fill(buttonColor)
                        .shadow(color: Color(#colorLiteral(red: 0.2986346781, green: 0.2874504924, blue: 0.3008843064, alpha: 1)), radius: 5, x: 0, y: 0)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: 5, y: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 15).foregroundColor(buttonColor)
                            .shadow(color: Color(#colorLiteral(red: 0.4459395409, green: 0.4322124422, blue: 0.4563130736, alpha: 1)), radius: 3, x: 2, y: 3)
                            .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
                    }
                }
            )
    }
}

struct SmallButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Group {
                    if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 15).fill(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: -5, y: -5)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: 5, y: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 15).fill(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}
