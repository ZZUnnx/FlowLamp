import cv2
import mediapipe as mp
import math

mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(refine_landmarks=True)

def dist(p1, p2):
    return math.hypot(p1.x - p2.x, p1.y - p2.y)

# EAR 계산 함수
def get_ear(landmarks, eye_indices):
    vertical1 = dist(landmarks[eye_indices[1]], landmarks[eye_indices[5]])
    vertical2 = dist(landmarks[eye_indices[2]], landmarks[eye_indices[4]])
    horizontal = dist(landmarks[eye_indices[0]], landmarks[eye_indices[3]])
    return (vertical1 + vertical2) / (2.0 * horizontal)

# 눈 랜드마크 (왼쪽/오른쪽)
LEFT_EYE = [33, 160, 158, 133, 153, 144]
RIGHT_EYE = [362, 385, 387, 263, 373, 380]

cap = cv2.VideoCapture(0)

blink_count = 0
blink_threshold = 0.20   # 👈 중요 (튜닝 포인트)
blink_frames = 0
blink_frame_limit = 2    # 👈 몇 프레임 유지되면 깜빡임 인정

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)
    h, w, _ = frame.shape

    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = face_mesh.process(rgb)

    if result.multi_face_landmarks:
        for face_landmarks in result.multi_face_landmarks:
            landmarks = face_landmarks.landmark

            left_ear = get_ear(landmarks, LEFT_EYE)
            right_ear = get_ear(landmarks, RIGHT_EYE)

            ear = (left_ear + right_ear) / 2.0

            # 눈 감김 판단
            if ear < blink_threshold:
                blink_frames += 1
            else:
                if blink_frames >= blink_frame_limit:
                    blink_count += 1
                blink_frames = 0

            # 디버그 출력
            cv2.putText(frame, f"EAR: {ear:.2f}", (50, 100),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

            # 눈 점 찍기
            for idx in LEFT_EYE + RIGHT_EYE:
                x = int(landmarks[idx].x * w)
                y = int(landmarks[idx].y * h)
                cv2.circle(frame, (x, y), 2, (0, 255, 0), -1)

    cv2.putText(frame, f"Blink Count: {blink_count}", (50, 50),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2)

    cv2.imshow("Blink Detection", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()