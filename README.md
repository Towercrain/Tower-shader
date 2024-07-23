# Tower shader

자작 마인크래프트 셰이더 팩  
버전 : 5.3

## 특징
- 저사양과 현실성을 지향하는 셰이더
- 픽셀아트 스타일의 그림자
- 새롭게 짜여진 라이트맵
- auto exposure (자동 노출 조정)
- LMS 공간에서 처리되는 톤 매핑
- 고급 질감 표현이 없음 (PBR 리소스팩 미지원)

### 테스트 환경

|             |  \| |  version < 1.2.4 |     version > 1.3 |
| :---------: | :-: | :--------------: |  :--------------: |
|         GPU |  \| |  Geforce GTX 660 |  Geforce RTX 4060 |
|  ShadersMod |  \| |         Optifine |  Iris Shaders Mod |
| Performance |  \| | stable at 40 FPS | stable at 200 FPS |

## 업데이트 기록

### 1.1
- 작성 예정

### 1.2
- 작성 예정

### 1.3
- 테스트 플랫폼을 Iris Shaders 모드로 옮김
- Iris Shaders에서 미지원하는 기능 비활성화
- 색 공간 관련 연산 개선
- 기준 색 공간을 Display-P3로 변경함
- 햇빛이 더 정확한 색상으로 보여짐
- 그림자 관련 설정 추가
- 최대 직교투영 거리 확장
- README.md 리워크

### 1.4
- 나중에 써야지

### 5
- 버전 형식 변경
- glsl 버전 변경
- 엔드 포탈의 그래픽 활성화 및 업데이트

## 스크린샷

![2024-07-23_19 04 25](https://github.com/user-attachments/assets/64a6e9a1-b9ad-4b62-8811-3d485c7a2aaa)
![2024-07-23_19 06 45](https://github.com/user-attachments/assets/14883d62-eb12-4022-bb47-bf7570d8fe73)

## todo

- 옵티파인 호환성 업데이트
- 업데이트 기록 작성하기
