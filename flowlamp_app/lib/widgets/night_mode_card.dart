import 'package:flutter/material.dart';

class NightModeCard extends StatefulWidget {
  const NightModeCard({Key? key}) : super(key: key);

  @override
  State<NightModeCard> createState() => _NightModeCardState();
}

class _NightModeCardState extends State<NightModeCard> {
  bool isNightModeOn = true;
  RangeValues _currentRangeValues = const RangeValues(23, 2); // 기본값: 23시 ~ 02시

  // 숫자를 시간 문자열로 변환 (예: 23 -> "23:00", 2 -> "02:00")
  String _formatTime(double value) {
    int hour = value.toInt();
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // 카드 너비 지정
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 상단: 아이콘, 텍스트, 스위치
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.dark_mode, color: Colors.grey.shade800, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "NIGHT MODE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              // 커스텀 스위치 (ON/OFF 글씨 포함)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isNightModeOn = !isNightModeOn;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: isNightModeOn ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: isNightModeOn ? 8 : null,
                        right: isNightModeOn ? null : 8,
                        child: Text(
                          isNightModeOn ? "ON" : "OFF",
                          style: TextStyle(
                            color: isNightModeOn ? Colors.white : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        left: isNightModeOn ? 32 : 2,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 중단: 양방향 시간 조절 슬라이더
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.grey.shade800,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: Colors.grey.shade100,
              overlayColor: Colors.grey.shade800.withOpacity(0.2),
              trackHeight: 4.0,
            ),
            child: RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 24,
              divisions: 24,
              onChanged: isNightModeOn 
                ? (RangeValues values) {
                    setState(() { _currentRangeValues = values; });
                  }
                : null, // 모드가 꺼져있으면 슬라이더 비활성화
            ),
          ),
          
          // 하단: 설정된 시간 범위 텍스트
          Text(
            '${_formatTime(_currentRangeValues.start)} ~ ${_formatTime(_currentRangeValues.end)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isNightModeOn ? Colors.grey.shade700 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}