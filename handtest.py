import cv2
import mediapipe as mp

# MediaPipe 설정
mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils

# 손 인식 객체 생성
hands = mp_hands.Hands(
    max_num_hands=2,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.7
)

# 카메라 실행
cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # 좌우 반전 (거울처럼)
    frame = cv2.flip(frame, 1)

    # BGR → RGB 변환
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # 손 인식
    result = hands.process(rgb_frame)

    # 손 랜드마크 그리기
    if result.multi_hand_landmarks:
        for hand_landmarks in result.multi_hand_landmarks:
            mp_drawing.draw_landmarks(
                frame,
                hand_landmarks,
                mp_hands.HAND_CONNECTIONS
            )

    # 화면 출력
    cv2.imshow('Hand Tracking', frame)

    # 종료 키 (q)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()