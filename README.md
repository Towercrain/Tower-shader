# Tower shader

자작 마인크래프트 셰이더 팩  
버전 : 1.3.1

## 특징
- 저사양과 현실성을 지향하는 셰이더
- 픽셀아트 스타일의 그림자
- 새롭게 짜여진 라이트맵
- auto exposure (자동 노출 조정)
- LMS 공간에서 처리되는 톤 매핑
- 고급 질감 표현이 없음 (PBR 리소스팩 미지원)

### 테스트 환경

|             |  \| |  version < 1.2.4 |    version > 1.3 |
| :---------: | :-: | :--------------: | :--------------: |
|         CPU |  \| |        i5 - 3550 |     i5 - 13600KF |
|         GPU |  \| |  Geforce GTX 660 | Geforce RTX 4060 |
|         RAM |  \| |      DDR3 4+4 GB |    DDR5 16+16 GB |
|  ShadersMod |  \| |         Optifine | Iris Shaders Mod |
| Performance |  \| | stable at 40 FPS |        작성 예정 |

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

## todo

- Iris Shaders 모드에서의 정상 구동을 위해, GLSL 버전 변경하기 (330 core -> 330 compatibility)
- 직교투영 개선하기
