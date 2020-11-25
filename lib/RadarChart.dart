import 'dart:math';
import 'package:flutter/material.dart';
class RadarChart extends StatelessWidget {
  var data1;
  var data2;
  var features;
  RadarChart(this.features, this.data1, this.data2);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: RadarChartPainter(this.features, this.data1, this.data2),
    ); }}
class RadarChartPainter extends CustomPainter {
  var features;
  var data1;
  var data2;
  RadarChartPainter(this.features, this.data1, this.data2);
  @override
  void paint(Canvas canvas, Size size) {
    var data = [data1, data2];
    var centerX = size.width / 2.0;
    var centerY = size.height / 2.0;
    var centerOffset = Offset(centerX, centerY);
    var radius = centerX * 0.8;
    var outlinePaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;
    canvas.drawCircle(centerOffset, radius, outlinePaint);
    var ticks;
    if(data[0].length == 5){
      ticks = [20, 30, 40];
    }
    else{
      ticks = [20, 30, 40];
    }
    var tickDistance = radius / (ticks.length);
    const double tickLabelFontSize = 12;
    var ticksPaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;
    ticks.sublist(0, ticks.length - 1).asMap().forEach((index, tick) {
      var tickRadius = tickDistance * (index + 1);
      canvas.drawCircle(centerOffset, tickRadius, ticksPaint);
      TextPainter(
        text: TextSpan(
          text: tick.toString(),
          style: TextStyle(color: Colors.white70, fontSize: tickLabelFontSize),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(
            canvas, Offset(centerX, centerY - tickRadius - tickLabelFontSize));
    });
    var angle = (2 * pi) / features.length;
    const double featureLabelFontSize = 16;
    const double featureLabelFontWidth = 12;
    features.asMap().forEach((index, feature) {
      var xAngle = cos(angle * index - pi / 2);
      var yAngle = sin(angle * index - pi / 2);
      var featureOffset =
      Offset(centerX + radius * xAngle, centerY + radius * yAngle);
      canvas.drawLine(centerOffset, featureOffset, ticksPaint);
      var labelYOffset = yAngle < 0 ? -featureLabelFontSize : 0;
      var labelXOffset = xAngle < 0 ? -featureLabelFontWidth * feature.length : 0;
      TextPainter(
        text: TextSpan(
          text: feature,
          style: TextStyle(color: Colors.white70, fontSize: featureLabelFontSize),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(
            canvas,
            Offset(featureOffset.dx + labelXOffset,
                featureOffset.dy + labelYOffset));
    });
    const graphColors = [Colors.green, Colors.blue];
    var scale = radius / ticks.last;
    data.asMap().forEach((index, graph) {
      var graphPaint = Paint()
        ..color = graphColors[index % graphColors.length].withOpacity(0.3)
        ..style = PaintingStyle.fill;
      var graphOutlinePaint = Paint()
        ..color = graphColors[index % graphColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;
      // Start the graph on the initial point
      var scaledPoint = scale * graph[0];
      var path = Path();
      path.moveTo(centerX, centerY - scaledPoint);
      graph.sublist(1).asMap().forEach((index, point) {
        var xAngle = cos(angle * (index + 1) - pi / 2);
        var yAngle = sin(angle * (index + 1) - pi / 2);
        var scaledPoint = scale * point;
        path.lineTo(
            centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
      });
      path.close();
      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    }); }
  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return false;
  }}
