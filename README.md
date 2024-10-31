# BeTime
## <요약>

사용자의 위치 기준에 따라 1시간마다 최신으로 업데이트된 데이터를 기반으로 
 날씨(기온, 강수확률)을 제공하고 사용자가 원하는 지역의 대한 날씨(기온,강수확률)을 제공한다.

## <제작 배경>

기존 날씨 앱보다 더 최신화 되어 보다 정확한 날씨 데이터를 사용자에게 제공하려고 합니다.


## <사용 아키텍처>
### Clean Architecture
<img src="https://github.com/user-attachments/files/17566490/default.pdf" width="60%">
크게 Presenter Layer, Domain Layer, Data Layer로 구성하였습니다.


각각 수행하는 역할은 
- Presenter: 사용자의 이벤트를 전달받고 View 업데이트, 상태관리
- Domain: 비즈니스 로직을 담당, 비즈니스 핵심 모델 보유
- Data: API를 통해 서버로 부터 날씨 데이터 요청.


## <앱 화면 구성>

<img src="https://github.com/user-attachments/assets/cbe29e92-a4d2-4488-a9dc-4a24da20fdec" width="20%">
<img src="https://github.com/user-attachments/assets/53303837-2da3-4e35-8454-4a43041c6239" width="20%">
<img src="https://github.com/user-attachments/assets/444a2118-1526-4d23-9657-253b8b93edc5" width="20%">
