## Class Description
- MultipeerTest의 Class는 Session Presenter, Observer, Audience로 구성됩니다
### SessionPresenter
- 발표자
- 현재 보내진 정보가 없는지 확인합니다
- 청중에게 초대를 보냅니다

### SessionObserver
- 관찰자
- 현재 세션을 연 사람(발표자)을 확인합니다
- 발표자의 초대를 감지합니다

### SessionAudience
- 청중
- 현재 열린 세션에 들어갑니다
- Observer로부터 받은 발표자의 정보를 바탕으로, 원하는 발표자의 세션에 들어갑니다

## View Flow
[![](https://mermaid.ink/img/pako:eNpNj8EKgzAMhl-l5Kwv0MPA6W4exoRd2h2KjbOgVWrKGNZ3X910mFPy5_t_khnqQSNweDo1tqy8SctiZSIfLKGlu8HXg6XpKVwdTlFAF9hZ_IfvfvOsGAuZ1wZtjYHlojQTHYj8R1TYYU3sEFiI3XWgIYEeXa-MjufNqyaBWuxRAo-txkb5jiRIu0TUj1oRXrShwQFvVDdhAsrTUL1tDZycxx0qjIrf9hu1fAC0sldi)](https://mermaid.live/edit#pako:eNpNj8EKgzAMhl-l5Kwv0MPA6W4exoRd2h2KjbOgVWrKGNZ3X910mFPy5_t_khnqQSNweDo1tqy8SctiZSIfLKGlu8HXg6XpKVwdTlFAF9hZ_IfvfvOsGAuZ1wZtjYHlojQTHYj8R1TYYU3sEFiI3XWgIYEeXa-MjufNqyaBWuxRAo-txkb5jiRIu0TUj1oRXrShwQFvVDdhAsrTUL1tDZycxx0qjIrf9hu1fAC0sldi)

### Mode: Presesnter
||ContentView|PresenterView|
|:---:|:---:|:---:|
|**SessionPresenter**|Exist|Browsing Start|
|**SessionObserver**|Non Exist|Non Exist|
|**SessionAudience**|Non Exist|Non Exist|

### Mode: Audience
||ContentView|**ListView**|**AudienceView**|
|:---:|:---:|:---:|:---:|
|**SessionPresenter**|Exist|Exist|Exist|
|**SessionObserver**|Non Exist|Exist|Non Exist|
|**SessionAudience**|Non Exist|Non Exist|Exist|
