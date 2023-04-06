//
//  RadarChart.swift
//  Chart_Test
//
//  Created by Ken Oonishi on 2022/06/18.
//

//TODO: Xcode14.0にアップデートしたら、ビルドエラーが発生してしまう

import SwiftUI



///  仮のパーソナリティデータ
let personalityData = [
    Personality(rayCase: .Intelligence, point: 5.8, display: true),
    Personality(rayCase: .Funny, point: 6.5, display: false),
    Personality(rayCase: .Empathy, point: 3.8, display: false),
    Personality(rayCase: .Veracity, point: 8.5, display: true),
    Personality(rayCase: .Selflessness, point: 7.6, display: false),
    Personality(rayCase: .Authenticity, point: 2.9, display: false),
    Personality(rayCase: .Boldness, point: 4.7, display: true),
    Personality(rayCase: .LookAdvantages, point: 3.2, display: false),
    Personality(rayCase: .Concern, point: 9.1, display: false),
    Personality(rayCase: .Humor, point: 7.6, display: true),
    Personality(rayCase: .Conversation, point: 6.3, display: false),
    Personality(rayCase: .Deductive, point: 5.5, display: true)
]




enum RayCase:String, CaseIterable {
    case Intelligence = "賢さ"
    case Funny = "面白さ"
    case Empathy = "共感性"
    case Veracity = "誠実さ"
    case Selflessness = "利他主義"
    case Authenticity = "信頼性"
    case Boldness = "大胆さ"
    case LookAdvantages = "長所探し"
    case Concern = "気遣い"
    case Humor = "ユーモア"
    case Conversation = "話術"
    case Deductive = "推理力"
}


/// パーソナリティの構造体
struct Personality {
    var rayCase: RayCase    //特徴一覧
    var point: Double       //ポイント
    var display: Bool       //表示
}

/// グラフデータの構造体
struct DataPoint:Identifiable {
    var id = UUID()
    var entrys:[RayEntry] = []
    var color:Color
    
    init(color: Color) {
        for i in 0..<personalityData.count {
            if personalityData[i].display {
                entrys.append(RayEntry(rayCase: personalityData[i].rayCase, value: personalityData[i].point))
            }
        }
        self.color = color
    }
}

struct Ray:Identifiable {
    var id = UUID()
    var name:String
    var maxVal:Double
    var rayCase:RayCase
    init(maxVal:Double, rayCase:RayCase) {
        self.rayCase = rayCase
        self.name = rayCase.rawValue
        self.maxVal = maxVal
    }
}

struct RayEntry {
    var rayCase:RayCase
    var value:Double
}

/// ラベル・グラフ数値の配列データ作成
func MakeDimensions() -> [Ray] {
    var dimensions:[Ray] = []
    
    for i in 0..<personalityData.count {
        if personalityData[i].display {
            dimensions.append(Ray(maxVal: 10, rayCase: personalityData[i].rayCase))
        }
    }
    return dimensions
}

/// グラフ1つ分のデータを作成
func MakeDataPoint() -> [DataPoint] {
    var data:[DataPoint] = []
    data.append(DataPoint(color: .orange))
    return data
}

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)) - 90)
}

func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return 360 * (CGFloat((numerator))/CGFloat(denominator)) - 90
}


// View本体はここから　------------
struct RadarChartView: View {
    
    var MainColor:Color
    var SubtleColor:Color
    var center:CGPoint
    var labelWidth:CGFloat = 60
    var labelOffset:CGFloat = 50
    var width:CGFloat
    var quantity_incrementalDividers:Int
    var dimensions:[Ray]
    var data:[DataPoint]
    
    init(width: CGFloat, MainColor:Color, SubtleColor:Color, quantity_incrementalDividers:Int, dimensions:[Ray], data:[DataPoint]) {
        self.width = width
        self.center = CGPoint(x: width / 2, y: width / 2)
        self.MainColor = MainColor
        self.SubtleColor = SubtleColor
        self.quantity_incrementalDividers = quantity_incrementalDividers
        self.dimensions = dimensions
        self.data = data
    }
    
    @State var showLabels = false
    
    var body: some View {
        
        ZStack{
            
            //Main Spokes
            Path { path in
                for i in 0..<self.dimensions.count {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    let x = (self.width - (labelOffset + self.labelWidth)) / 2 * cos(angle)
                    let y = (self.width - (labelOffset + self.labelWidth)) / 2 * sin(angle)
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                }
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

            //Labels
            ForEach(0..<self.dimensions.count, id: \.self) { i in
                Text(self.dimensions[i].rayCase.rawValue)
                    .font(.system(size: 12))
                    .foregroundColor(self.MainColor)
                    .frame(width:self.labelWidth, height: 10)
                    .rotationEffect(.degrees(-degAngle_fromFraction(numerator: i, denominator: self.dimensions.count)))
//                    .rotationEffect(.degrees(
//                        (degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) > 90 && degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) < 270) ? 180 : 0
//                        ))
                    .background(Color.clear)
                    .offset(x: (self.width - (labelOffset))/2)
                    .rotationEffect(.radians(
                        Double(radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    )))
            }
            
            //Outer Border
            Path { path in
                for i in 0..<self.dimensions.count + 1 {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    let x = (self.width - (labelOffset + self.labelWidth)) / 2 * cos(angle)
                    let y = (self.width - (labelOffset + self.labelWidth)) / 2 * sin(angle)
                    if i == 0 {
                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                    }
                }
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            //Incremental Dividers
            ForEach(0..<self.quantity_incrementalDividers, id: \.self) { j in
                Path { path in
                    for i in 0..<self.dimensions.count + 1 {
                        let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                        let size = ((self.width - (labelOffset + self.labelWidth)) / 2) * (CGFloat(j + 1)/CGFloat(self.quantity_incrementalDividers + 1))
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        print(size)
                        print((self.width - (labelOffset + self.labelWidth)))
                        print("\(x) -- \(y)")
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                    }
                }
                .stroke(self.SubtleColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            }
            
            //Data Polygons
            ForEach(0..<self.data.count, id: \.self){j -> AnyView in
                //Create the path
                let path = Path { path in
                    for i in 0..<self.dimensions.count + 1 {
                        let thisDimension = self.dimensions[i == self.dimensions.count ? 0 : i]
                        let maxVal = thisDimension.maxVal

                        let dataPointVal:Double = {
                            for DataPointRay in self.data[j].entrys {
                                if thisDimension.rayCase == DataPointRay.rayCase {
                                    return DataPointRay.value
                                }
                            }
                            return 0
                        }()

                        let angle = radAngle_fromFraction(numerator: i == self.dimensions.count ? 0 : i, denominator: self.dimensions.count)
                        let size = ((self.width - (labelOffset + self.labelWidth))/2) * (CGFloat(dataPointVal)/CGFloat(maxVal))
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        print(size)
                        print((self.width - (labelOffset + self.labelWidth)))
                        print("\(x) -- \(y)")
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                    }
                }
                
                //Stroke and Fill
                return AnyView (
                    ZStack {
                        path
                            .stroke(self.data[j].color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        path
                            .foregroundColor(self.data[j].color).opacity(0.2)
                    }
                )
            }
            
        } //ZStack
        .frame(width:width, height:width)
    }
}


//struct RadarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        RadarChartView()
//    }
//}
