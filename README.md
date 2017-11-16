
# SmartAlbum

- A팀 멘티 : 김선일님, 정진호님
- B팀 멘티 : 진형탁님, 홍성호님

## 제목 : 머신러닝을 활용한 스마트앨범

### 주제 선정 배경
스마트폰의 필수 앱인 사진 앨범앱을 제작해 봄으로써 앱 개발의 전반적인 기술을 사용해 보고 아울러 CoreML을 적용하고 개선해 봄으로써 머신러닝이 어떻게 서비스에 접목될 수 있는지 경험해 볼 수 있다.

### 요구사항(필수)
- 디바이스에 저장된 사진 및 영상들의 목록을 볼 수 있고 viewer를 제공한다.
- 머신러닝 모델을 적용하여 사진을 키워드로 분류한다. (최신 사진부터 순차적으로 분류하고 목록에 실시간 반영)
- 앨범 목록에서 각 키워드 및 사진의 위치정보, 촬영시간으로 그루핑 및 검색이 가능하다.
- 분류 키워드 등의 메타정보는 적절한 데이터베이스를 선택하여 저장하고 성능을 튜닝한다.
- 분류가 끝난 사진과 그렇지 않은 사진을 목록에서 알 수 있고 갱신된다.

### 요구사항(선택)
- os 기본 사진앱에서 제공하는 기능을 제공하거나 개선해서 사용성을 높인다.
- 머신러닝 모델을 고도화 하거나 2개 이상 적용하여 분류 키워드 품질을 높인다.
- cpu 사용이 큰 작업(키워드 분류 등)들을 앱 유휴상태에서 스케쥴링하여 응답속도를 개선한다.
- 분류 키워드는 영어, 한국어를 기본으로 2개 국어 이상을 지원한다.

### 개발언어
Swift, Objective-C

### 플랫폼
iOS
