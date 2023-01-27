//
//  ContentView.swift
//  calculator
//
//  Created by yook on 2022/12/08.
//

import SwiftUI


enum Buttontype {
    case first, second, third, fourth, fifth, sixth, seventh, eighth, nineth, zero
    case dot, equal, plus, minus, multiple, devide
    case percent, opposite, clear
    
    var ButtonDisplayname: String {
        switch self {
        case .first :
            return "1"
        case .second :
            return "2"
        case .third :
            return "3"
        case .fourth :
            return "4"
        case .fifth :
            return "5"
        case .sixth :
            return "6"
        case .seventh :
            return "7"
        case .eighth :
            return "8"
        case .nineth :
            return "9"
        case .zero :
            return "0"
        case .equal :
            return "="
        case .plus :
            return "+"
        case .minus :
            return "-"
        case .multiple :
            return "X"
        case .devide :
            return "/"
        case .percent :
            return "%"
        case .opposite :
            return "+/-"
        case .clear :
            return "A/C"
        case .dot :
            return "."
        default:
            return "?"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .first, .second, .third, .fourth, .fifth, .sixth, .seventh,
                .eighth, .nineth, .zero, .dot:
            return Color("NumberButton")
        case .equal, .plus, .minus, .multiple, .devide:
            return Color.orange
        case .percent, .opposite, .clear:
            return Color.gray
        }
    }
    
    var forgroundColor: Color {
        switch self {
        case .first, .second, .third, .fourth, .fifth, .sixth, .seventh,
                .eighth, .nineth, .zero, .dot, .equal, .plus, .minus, .multiple, .devide:
            return Color.white
        case .percent, .opposite, .clear:
            return Color.black
        }
    }
}

struct ContentView: View {
    
    @State private var totalNumber: String = "0" //결과값 저장
    @State private var PreviousResult: String = "0" //결과값 저장
    @State private var RealtimeResult: String = "0" //결과값 저장
    @State var tempNumber: Int = 0 // 계산용
    @State var first_Number: Int = 0 //첫 입력 저장
    @State var after_Number: Int = 0 //나중 입력 저장
    @State var operatorType: Buttontype = .clear
    @State var ItisEmpty: Bool = true
    @State var first_data_exist: Bool = false
    @State var after_data_exist: Bool = false
    
    
    private let buttonData: [[Buttontype]] = [
        [.clear, .opposite, .percent, .devide],
        [.seventh, .eighth, .nineth, .multiple],
        [.fourth, .fifth, .sixth, .minus],
        [.first, .second, .third, .plus],
        [.zero, .dot, .equal]
    ]
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text(PreviousResult)
                        .padding()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                HStack {
                    Spacer()
                    Text(RealtimeResult)
                        .padding()
                        .font(.system(size: 53))
                        .foregroundColor(.white)
                }
                HStack{
                    Spacer()
                    Text(totalNumber)
                        .padding()
                        .font(.system(size: 73))
                        .foregroundColor(.white)
                }
                    
                ForEach(buttonData, id: \.self)  { line in
                    HStack {
                        ForEach(line, id: \.self) { item in
                            Button {
                                if ItisEmpty { // 현재 입력 공간에 아무것도 없을때
                                    if item == .clear ||
                                        item == .plus ||
                                        item == .minus ||
                                        item == .multiple ||
                                        item == .devide ||
                                        item == .opposite ||
                                        item == .percent ||
                                        item == .equal { // 입력없이 연산자를 누를떄 무반응
                                        ItisEmpty = true
                                    } else { // 첫번쨰 숫자 저장 및 디스플레이
                                        ItisEmpty = false
                                        if operatorType != .clear {
                                            totalNumber = item.ButtonDisplayname
                                            after_Number = Int(totalNumber) ?? 0
                                            //
                                            if operatorType == .plus {
                                                RealtimeResult = String(first_Number + after_Number)
                                            } else if operatorType == .multiple {
                                                RealtimeResult = String(first_Number * after_Number)
                                            } else if operatorType == .minus {
                                                RealtimeResult = String(first_Number - after_Number)
                                            }
                                            //
                                        } else {
                                            totalNumber = item.ButtonDisplayname
                                        }
                                    }
                                } else { // 두번째 입력
                                    if item == .clear {
                                        first_Number = 0
                                        totalNumber = "0"
                                        after_Number = 0
                                        PreviousResult = "0"
                                        RealtimeResult = "0"
                                        ItisEmpty = true
                                    } else if item == .plus {
                                        first_Number = Int(totalNumber) ?? 0
                                        operatorType = .plus
                                        totalNumber += "+"
                                        ItisEmpty = true
                                        print(first_Number)
                                    } else if item == .multiple {
                                        first_Number = Int(totalNumber) ?? 0
                                        operatorType = .multiple
                                        totalNumber += "X"
                                        ItisEmpty = true
                                    } else if item == .minus {
                                        first_Number = Int(totalNumber) ?? 0
                                        operatorType = .minus
                                        totalNumber += "-"
                                        ItisEmpty = true
                                    } else if item == .opposite {
                                        print(totalNumber)
                                        tempNumber = Int(totalNumber) ?? 0
                                        tempNumber *= -1
                                        print(tempNumber)
                                        totalNumber = String(tempNumber)
                                    }
                                    
                                    else if item == .equal {
                                          if operatorType == .plus ||
                                             operatorType == .multiple ||
                                             operatorType == .minus {
                                              totalNumber = RealtimeResult
                                              RealtimeResult = "0"
                                          }
                                        first_Number = Int(totalNumber) ?? 0
                                        PreviousResult = totalNumber
                                        }
 
                                       else {
                                           totalNumber += item.ButtonDisplayname
                                           if operatorType != .clear {
                                               after_Number = Int(totalNumber) ?? 0
                                           }

                                       }
                                }
                            } label: {
                                Text(item.ButtonDisplayname)
                                    .frame(width: calculateButtonWidth(button: item),
                                           height: calculateButtonHeight(button: item))
                                    .background(item.backgroundColor)
                                    .cornerRadius(40)
                                    .foregroundColor(item.forgroundColor)
                                    .font(.system(size: 33))
                            }
                        }
                    }
                }
                
            }
        }
       
    }
    
    private func calculateButtonWidth(button buttontype: Buttontype) -> CGFloat {
        switch buttontype {
        case .zero:
            return (UIScreen.main.bounds.width - 5 * 10) / 4 * 2
        default:
            return ((UIScreen.main.bounds.width - 5 * 10) / 4 )
        }
    }
    
    private func calculateButtonHeight(button: Buttontype) -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 10 ) / 4
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
