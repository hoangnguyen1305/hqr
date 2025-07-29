part of '../home_page.dart';

class TimeUI extends StatefulWidget {
  const TimeUI({super.key});

  @override
  State<TimeUI> createState() => _TimeUIState();
}

class _TimeUIState extends State<TimeUI> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy');
    final hourFormatter = DateFormat('HH'); // Giờ: 10
    final minuteFormatter = DateFormat('mm'); // Phút: 25
    final secondFormatter = DateFormat('ss');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dateFormatter.format(_currentTime),
          style: const TextStyle(
            fontSize: FontSizeRes.header * 1.2,
            fontWeight: FontWeight.bold,
            color: ColorRes.blue,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorRes.backgroundGreyColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorRes.grey, width: 1),
              ),
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: CText(
                text: hourFormatter.format(_currentTime),
                fontSize: FontSizeRes.header * 1.8,
                fontWeight: FontWeight.w500,
                color: ColorRes.textColor,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ConstRes.defaultVertical,
              ),
              child: CText(
                text: ':',
                fontSize: FontSizeRes.header * 1.8,
                fontWeight: FontWeight.w500,
                color: ColorRes.textColor,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorRes.backgroundGreyColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorRes.grey, width: 1),
              ),
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: CText(
                text: minuteFormatter.format(_currentTime),
                fontSize: FontSizeRes.header * 1.8,
                fontWeight: FontWeight.w500,
                color: ColorRes.textColor,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ConstRes.defaultVertical,
              ),
              child: CText(
                text: ':',
                fontSize: FontSizeRes.header * 1.8,
                fontWeight: FontWeight.w500,
                color: ColorRes.textColor,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorRes.backgroundGreyColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorRes.grey, width: 1),
              ),
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: CText(
                text: secondFormatter.format(_currentTime),
                fontSize: FontSizeRes.header * 1.8,
                fontWeight: FontWeight.w500,
                color: ColorRes.textColor,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
