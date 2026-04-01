import 'package:flutter/material.dart';
import 'widgets/focus_timer.dart';
import 'widgets/night_mode_card.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // 뒤로가기 버튼이 차지하는 가로 길이를 제한
        leadingWidth: 64, 
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            // 아이콘 주변으로만 동그랗게 호버 효과가 나타나도록 반경 제한
            splashRadius: 24, 
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(height: 20),
                FocusTimerSection(),
                SizedBox(height: 50),
                NightModeCard(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}