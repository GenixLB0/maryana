import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:nb_utils/nb_utils.dart' hide primaryTextStyle;

double pixelCountInMm = 7.874015748031496;

class SizeGuideView extends StatefulWidget {
  const SizeGuideView(
      {super.key,
      required this.selectedFitType,
      required this.selectedStretch,
      required this.selectedAttr});

  final String selectedFitType;
  final String selectedStretch;
  final List<Attr> selectedAttr;

  @override
  State<SizeGuideView> createState() => _SizeGuideState();
}

class _SizeGuideState extends State<SizeGuideView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  int stretchValue = 0;

  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.selectedStretch == "None") {
      stretchValue = 0;
      setState(() {});
    } else if (widget.selectedStretch == "Slight") {
      stretchValue = 1;
      setState(() {});
    } else if (widget.selectedStretch == "Medium") {
      stretchValue = 2;
      setState(() {});
    } else {
      stretchValue = 3;
      setState(() {});
    }

    TabController tabController = TabController(length: 2, vsync: this);
    // void _handleTabChange() {
    //   print('Selected tab index: ${tabController.index}');
    //
    //   // Add your custom logic here when the tab changes
    // }

    // tabController.addListener(_handleTabChange);
    List<String> fitTypeList = [
      "Skinny",
      "Slim",
      "Regular",
      "Oversized",
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Size Guide')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fit Type',
                  style: primaryTextStyle(
                      size: 18.sp.round(), weight: FontWeight.w700)),
              SizedBox(
                height: 5.h,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: fitTypeList
                      .map(
                        (value) => value == widget.selectedFitType
                            ? ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    maximumSize: WidgetStateProperty.all(
                                        Size(85.w, 40.h)),
                                    backgroundColor: WidgetStateProperty.all(
                                        Colors.purpleAccent)),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  value,
                                  style: primaryTextStyle(
                                      color: Colors.white, size: 8.sp.round()),
                                ),
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                    maximumSize: WidgetStateProperty.all(
                                        Size(85.w, 40.h))),
                                onPressed: () {},
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  value,
                                  style: primaryTextStyle(size: 8.sp.round()),
                                )),
                      )
                      .toList()),
              SizedBox(height: 20),
              Text('Stretch',
                  style: primaryTextStyle(
                      size: 18.sp.round(), weight: FontWeight.w700)),
              Slider(
                value: stretchValue.toDouble(),
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {},
                label: widget.selectedStretch,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'None',
                    style: primaryTextStyle(),
                  ),
                  Text(
                    'Slight',
                    style: primaryTextStyle(),
                  ),
                  Text(
                    'Medium',
                    style: primaryTextStyle(),
                  ),
                  Text(
                    'High',
                    style: primaryTextStyle(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TabBar(
                labelStyle: primaryTextStyle(size: 12.sp.round()),
                //For Selected tab
                unselectedLabelStyle: primaryTextStyle(size: 12.sp.round()),
                controller: tabController,
                tabs: const [
                  Tab(
                    text: 'Product Measurements',
                  ),
                  Tab(
                    text: 'Body Measurements',
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 35.h * widget.selectedAttr.length,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey),
                          children: [
                            _buildTitleCell('Size'),
                            _buildTitleCell('Length'),
                            _buildTitleCell('Waist Size'),
                            _buildTitleCell('Hip Size'),
                            _buildTitleCell('Bust'),
                          ],
                        ),
                        for (var attr in widget.selectedAttr
                            .where((attry) => attry.type == "product"))
                          TableRow(
                            children: [
                              _buildDataCell(attr.size!),
                              _buildDataCell(attr.length!),
                              _buildDataCell(attr.waist!),
                              _buildDataCell(attr.hip!),
                              _buildDataCell(attr.bust!),
                            ],
                          ),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey),
                          children: [
                            _buildTitleCell('Size'),
                            _buildTitleCell('Length'),
                            _buildTitleCell('Waist Size'),
                            _buildTitleCell('Hip Size'),
                            _buildTitleCell('Bust'),
                          ],
                        ),
                        for (var attr in widget.selectedAttr
                            .where((attry) => attry.type == "body"))
                          TableRow(
                            children: [
                              _buildDataCell(attr.size!),
                              _buildDataCell(attr.length!),
                              _buildDataCell(attr.waist!),
                              _buildDataCell(attr.hip!),
                              _buildDataCell(attr.bust!),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Text("How to Measure The Product Size ?"),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: MeasurementItem(
                      number: '1',
                      title: 'Shoulder',
                      description:
                          'Measure from where the shoulder seam meets the sleeve on one side to another side.',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        "assets/images/product/how-to-measure-for-clothing.jpg",
                        height: 130.h,
                        width: 130.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  MeasurementItem(
                    number: '2',
                    title: 'Bust',
                    description:
                        'Measure from the stitches below the armpits on one side to another.',
                  ),
                  MeasurementItem(
                    number: '3',
                    title: 'Top Length',
                    description:
                        'Measure from where the shoulder seam meets the collar to the hem.',
                  ),
                  MeasurementItem(
                    number: '4',
                    title: 'Sleeves',
                    description:
                        'Measure from where the shoulder seam meets armhole to the cuff.',
                  ),
                  MeasurementItem(
                    number: '5',
                    title: 'Bottom Waist',
                    description:
                        'Measure straight across the top of the waistband from edge to edge.',
                  ),
                  MeasurementItem(
                    number: '6',
                    title: 'Hips',
                    description:
                        'Measure straight across the widest hip line from edge to edge.',
                  ),
                  MeasurementItem(
                    number: '7',
                    title: 'Thigh',
                    description:
                        'Measure across straight from the crotch seam to the outside of the leg.',
                  ),
                  MeasurementItem(
                    number: '8',
                    title: 'Bottom Length',
                    description:
                        'Measure from the waistband to the leg opening or hem.',
                  ),
                  MeasurementItem(
                    number: '9',
                    title: 'Inseam',
                    description:
                        'Measure the length from the crotch seam to the bottom of the leg.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeasurementItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  MeasurementItem(
      {required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(number),
      ),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}

Widget _buildTitleCell(String title) {
  return TableCell(
    child: Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(title,
          style: primaryTextStyle(
              color: Colors.white,
              weight: FontWeight.w700,
              size: 15.sp.round())),
    ),
  );
}

Widget _buildDataCell(String data) {
  return TableCell(
    child: Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(data),
    ),
  );
}

class RulerPainter extends CustomPainter {
  final double indicatorSpacing = 20.0; // Adjust this value for spacing

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final startPoint = Offset(50, 50);
    final endPoint = Offset(size.width - 50, 50);

    // Draw the ruler line
    canvas.drawLine(startPoint, endPoint, paint);

    // Draw indicators at the start, end, and in between
    _drawIndicator(canvas, startPoint, '0');
    for (double x = startPoint.dx + indicatorSpacing;
        x < endPoint.dx;
        x += indicatorSpacing) {
      _drawIndicator(canvas, Offset(x, startPoint.dy),
          ((x - startPoint.dx) / indicatorSpacing).toString());
    }
    _drawIndicator(canvas, endPoint,
        ((endPoint.dx - startPoint.dx) / indicatorSpacing).toString());
  }

  void _drawIndicator(Canvas canvas, Offset position, String label) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final indicatorStart = Offset(position.dx, position.dy - 10);
    final indicatorEnd = Offset(position.dx, position.dy + 10);
    canvas.drawLine(indicatorStart, indicatorEnd, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: "",
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(position.dx - textPainter.width / 2, position.dy + 12));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
