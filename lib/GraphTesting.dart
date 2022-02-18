// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// // void main() {
// //   runApp(LineChartDemo());
// // }
//
// class LineChartDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           title: Text("Line chart animation demo"),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: LineChart(),
//         ),
//       ),
//     );
//   }
// }
//
// class LineData {
//   Map<String, double> data = new Map();
//   String category;
//   Color color;
//
//   LineData(String category, Color color, List<double> values) {
//     this.data = createCumulativeData(values);
//     this.category = category;
//     this.color = color;
//   }
//
//   Map<String, double> createCumulativeData(List<double> values) {
//     Map<String, double> data = new Map();
//     int c = 0;
//     double sum = 0;
//     values.forEach((element) {
//       sum += element;
//       data.putIfAbsent(c.toString(), () => sum);
//       c++;
//     });
//     return data;
//   }
// }
//
// class LineChart extends StatelessWidget {
//   static List<double> hamilton = [0,  15, 25];
//   static List<double> bottas = [0, 25, 18, 15, 0, 15, 16, 18, 10, 18, 26, 0];
//   static List<double> max = [0, 0, 15, 18, 19, 25, 18, 15, 10, 5, 3, 2];
//
//   final List<LineData> data = [
//     LineData("Hamilton", Colors.teal[700], hamilton),
//     LineData("Bottas", Colors.teal[300], bottas),
//     LineData("Verstappen", Colors.blue[900], max)
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//         tween: Tween<double>(begin: 0, end: 100),
//         duration: Duration(seconds: 8),
//         builder: (BuildContext context, double percentage, Widget child) {
//           return CustomPaint(
//             painter:
//             LineChartPainter(percentage, data, "Top Three Formula One"),
//             child: Container(width: double.infinity, height: 340),
//           );
//         });
//   }
// }
//
// class LineChartPainter extends CustomPainter {
//   final String title;
//   final List<LineData> lineData;
//   List<String> categories;
//   final double percentage;
//
//   double marginLeft;
//   double marginTop;
//   double marginBottom;
//   double marginRight;
//   double maxValue = 250;
//   static double emptySpace = 5;
//
//   // title
//   static double titleTextScale = 1.5;
//
//   // axis
//   static double axisWidth = 2;
//   static double axisTextScale = 1;
//
//   // two main lines
//   Paint axis = Paint()
//     ..strokeWidth = axisWidth
//     ..color = Colors.grey;
//
//   // horizontal lines through the chart
//   Paint axisLight = Paint()
//     ..strokeWidth = axisWidth
//     ..color = Colors.grey.withOpacity(0.5);
//
//   // legend
//   static double legendSquareWidth = 10;
//   static double legendTextScale = 1;
//
//   LineChartPainter(this.percentage, this.lineData, this.title) {
//     // margin left side is based on largest value on the axis
//     marginLeft = createText(maxValue.toString(), 1).width + emptySpace;
//     // determine where to begin with , based on height of the title
//     marginTop = createText(title, titleTextScale).height + emptySpace;
//     // determine marginBottom on default text
//     marginBottom = createText("1", axisTextScale).height * 2 + emptySpace;
//     // determine marginRight based on the largest category name
//     marginRight = 0;
//     lineData.forEach((element) {
//       var width = createText(element.category, legendTextScale).width +
//           legendSquareWidth +
//           emptySpace;
//       if (width > marginRight) {
//         marginRight = width;
//       }
//     });
//
//     // set the categories, based on the entries of the first data
//     categories = lineData[0].data.keys.toList();
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     drawTitle(canvas, size);
//     drawAxes(canvas, size);
//     drawLegend(canvas, size);
//     drawLines(size, canvas);
//   }
//
//   void drawLines(Size size, Canvas canvas) {
//     var index = 0;
//     lineData.forEach((element) {
//       var percentageCorrected = lineData.length *
//           min(percentage - index * 100 / (lineData.length),
//               100 / (lineData.length));
//
//       var points = element.data.entries.toList();
//       for (int i = 0; i < (points.length - 1); i++) {
//         var percentageOfLine = (points.length - 1) *
//             min(percentageCorrected - i * 100 / (points.length - 1),
//                 100 / (points.length - 1));
//         if (percentageOfLine > 0) {
//           var firstPoint = entryToPoint(points[i], size);
//           var goalPoint = entryToPoint(points[i + 1], size);
//           var nextPoint = new Offset(
//               percentageOfLine / 100 * (goalPoint.dx - firstPoint.dx) +
//                   firstPoint.dx,
//               percentageOfLine / 100 * (goalPoint.dy - firstPoint.dy) +
//                   firstPoint.dy);
//           canvas.drawLine(
//               entryToPoint(points[i], size), nextPoint, getLinePaint(element));
//           canvas.drawCircle(firstPoint, 5, getLineDataColorPaint(element));
//         }
//       }
//       if (percentageCorrected >= 99.9) {
//         canvas.drawCircle(entryToPoint(points[points.length - 1], size), 5,
//             getLineDataColorPaint(element));
//       }
//       index++;
//     });
//   }
//
//   void drawLegend(Canvas canvas, Size size) {
//     double i = 0;
//     lineData.forEach((element) {
//       TextPainter tp = createText(element.category, legendTextScale);
//       tp.paint(
//           canvas,
//           new Offset(
//               size.width - marginRight + legendSquareWidth + 2 * emptySpace,
//               (i * tp.height + marginTop - tp.height / 2)));
//       var center = new Offset(
//           size.width - marginRight + legendSquareWidth + emptySpace,
//           (i * tp.height + marginTop));
//       canvas.drawRect(
//           Rect.fromCenter(
//               center: center,
//               width: legendSquareWidth,
//               height: legendSquareWidth),
//           getLineDataColorPaint(element));
//       i++;
//     });
//   }
//
//   void drawTitle(Canvas canvas, Size size) {
//     TextPainter tp = createText(title, titleTextScale);
//     tp.paint(canvas, new Offset(size.width / 2 - tp.width / 2, 0));
//   }
//
//   Paint getLinePaint(LineData lineData) {
//     return new Paint()
//       ..strokeWidth = 4
//       ..color = lineData.color.withOpacity(0.5);
//   }
//
//   Paint getLineDataColorPaint(LineData lineData) {
//     return new Paint()
//       ..strokeWidth = 4
//       ..color = lineData.color;
//   }
//
//   void drawAxes(Canvas canvas, Size size) {
//     // draw the horizontal line
//     canvas.drawLine(
//       Offset(marginLeft, size.height - marginTop),
//       Offset(size.width - marginRight, size.height - marginTop),
//       axis,
//     );
//     // draw the vertical line
//     canvas.drawLine(
//       Offset(marginLeft, size.height - marginTop),
//       Offset(marginLeft, marginTop),
//       axis,
//     );
//     // draw the categories on the horizontal axis
//     addCategoriesAsTextToHorizontalAxis(size, canvas);
//     // draw five sizes on the vertical axis and draw lighter vertical lines
//     addHorizontalLinesAndSizes(size, canvas);
//   }
//
//   void addHorizontalLinesAndSizes(Size size, Canvas canvas) {
//     for (int i = 1; i <= 5; i++) {
//       double y = chartHeight(size) - chartHeight(size) * (i / 5) + marginTop;
//       TextPainter tp = createText((maxValue / 5 * i).round().toString(), 1);
//       tp.paint(canvas,
//           new Offset(marginLeft - tp.width - emptySpace, y - emptySpace));
//
//       canvas.drawLine(
//         Offset(marginLeft, y),
//         Offset(size.width - marginRight, y),
//         axisLight,
//       );
//     }
//   }
//
//   void addCategoriesAsTextToHorizontalAxis(Size size, Canvas canvas) {
//     categories.forEach((entry) {
//       TextPainter tp = createText(entry, 1);
//       var x = chartWidth(size) *
//           categories.indexOf(entry) /
//           (categories.length - 1) +
//           marginLeft -
//           tp.width / 2;
//       tp.paint(
//           canvas, new Offset(x, chartHeight(size) + marginTop + tp.height / 2));
//     });
//   }
//
//   TextPainter createText(String key, double scale) {
//     TextSpan span =
//     new TextSpan(style: new TextStyle(color: Colors.grey[600]), text: key);
//     TextPainter tp = new TextPainter(
//         text: span,
//         textAlign: TextAlign.start,
//         textScaleFactor: scale,
//         textDirection: TextDirection.ltr);
//     tp.layout();
//     return tp;
//   }
//
//   Offset entryToPoint(MapEntry<String, double> entry, Size size) {
//     double x = chartWidth(size) *
//         categories.indexOf(entry.key) /
//         (categories.length - 1) +
//         marginLeft;
//     double y = chartHeight(size) -
//         chartHeight(size) * (entry.value / maxValue) +
//         marginTop;
//     return new Offset(x, y);
//   }
//
//   double chartHeight(Size size) => size.height - marginTop - marginBottom;
//
//   double chartWidth(Size size) => size.width - marginRight - marginLeft;
//
//   @override
//   bool shouldRepaint(LineChartPainter oldDelegate) =>
//       oldDelegate.percentage != percentage;
// }
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget {
  // Generate some dummy data for the cahrt

  final List<FlSpot> dummyData1 = List.generate(12, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  final List<FlSpot> dummyData2 = List.generate(12, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  final List<FlSpot> dummyData3 = List.generate(12, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: LineChart(

                LineChartData(
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dummyData1,
                      isCurved: true,
                      barWidth: 3,
                      colors: [
                        Colors.red,
                      ],
                    ),
                    LineChartBarData(
                      spots: dummyData2,
                      isCurved: true,
                      barWidth: 3,
                      colors: [
                        Colors.orange,
                      ],
                    ),
                    LineChartBarData(
                      spots: dummyData3,
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.blue,
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}