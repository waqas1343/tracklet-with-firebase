import 'package:flutter/material.dart';

class OrderAnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkBlue = Color(0xFF13324B);
    final lightBlue = Color(0xFFB6D2F5);
    final backGray = Color(0xFFEFF2F7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 14, right: 14),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: backGray,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Order Analytics",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 18),

            // Orders Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Orders Summary',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  // Orders Delivered Card
                  Expanded(
                    child: Container(
                      height: 78,
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Orders\nDelivered Today',
                                    style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500, height: 1.2),
                                  ),
                                  Spacer(),
                                  Text(
                                    '08',
                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, height: 1.1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF305575),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Icon(Icons.local_shipping_outlined, size: 18, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Gas Ordered Card
                  Expanded(
                    child: Container(
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: backGray),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Gas\nOrdered',
                                    style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500, height: 1.2),
                                  ),
                                  Spacer(),
                                  Text(
                                    '1.2 Tons',
                                    style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold, height: 1.1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            // Top Plant Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Top Plant This Month',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),

            // Card and donut chart + details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: backGray),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Most Ordered',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            'View Details ',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: darkBlue),
                          ),
                          Icon(Icons.open_in_new, size: 14, color: darkBlue)
                        ],
                      ),
                      SizedBox(height: 8),
                      // Donut chart + Center text
                      SizedBox(
                        height: 135,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CustomPaint(
                                painter: _DonutChartPainter(),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Orders',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '28',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: darkBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Orders Table
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              SizedBox(),
                              Center(child: Text("Orders", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                              Center(child: Text("%", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            ],
                          ),
                          TableRow(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: darkBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text("Tracklet.CO", style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              Center(child: Text("28", style: TextStyle(fontSize: 13))),
                              Center(child: Text("62.5%", style: TextStyle(fontSize: 13))),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                            ],
                          ),
                          TableRow(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: lightBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text("BlueFlame", style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              Center(child: Text("15", style: TextStyle(fontSize: 13))),
                              Center(child: Text("25%", style: TextStyle(fontSize: 13))),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                            ],
                          ),
                          TableRow(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE9F1FB),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text("PureGas", style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              Center(child: Text("8", style: TextStyle(fontSize: 13))),
                              Center(child: Text("12.5%", style: TextStyle(fontSize: 13))),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Donut chart for top plants
class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 20.0;
    Rect rect = Offset.zero & size;

    Paint trackletPaint = Paint()
      ..color = Color(0xFF13324B)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint blueFlamePaint = Paint()
      ..color = Color(0xFFB6D2F5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint pureGasPaint = Paint()
      ..color = Color(0xFFE9F1FB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startRadian = -1.55;
    double trackletSweep = 3.93; // 62.5%
    double blueSweep = 1.57;     // 25%
    double pureSweep = 0.785;    // 12.5%

    canvas.drawArc(rect, startRadian, trackletSweep, false, trackletPaint);
    canvas.drawArc(rect, startRadian + trackletSweep, blueSweep, false, blueFlamePaint);
    canvas.drawArc(rect, startRadian + trackletSweep + blueSweep, pureSweep, false, pureGasPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
