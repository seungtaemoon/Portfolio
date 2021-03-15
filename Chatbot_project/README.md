# 카카오톡 감정교류형 챗봇을 만들기 위한 Transformer 자연어처리(NLP) 모델 구현 프로젝트

의사신문의 기사 [의사신문, 2020, “여성·젊은층에 더 짙게 드리우는 ‘코로나 블루’의 그늘”](http://www.doctorstimes.com/news/articleView.html?idxno=213187)에 따르면, 비대면 코로나 시대에 특히 젋은층과 여성들이 이전 보다 우울증을 더 많이 느낀다고 한다. 이러한 사회적 단절감과 우울감을 기회로 삼아, 다른 어떤 존재와 감정적 교류를 나누고 싶은 사람들의 욕구를 만족시킬 수 있는 챗봇을 만들어 보는 것은 어떨까하는 아이디어를 제시했다. 뉴시안 기사인 [뉴시안, 2020, “챗봇, 국내 시장 성장률 51%에 달해…“코로나로 변화된 업무 환경 협업도구로 사용 중”](http://www.newsian.co.kr/news/articleView.html?idxno=44459)이라는 기사에 따르면, 국내 챗봇 시장은 51% 정도로 성장하고 있다. 카카오는 카카오톡이라는 국민 메신저를 바탕으로 이 챗봇 시장에서도 압도적인 우위를 점할 수 있다. 먼저, “이루다" 같은 사태가 일어나지 않도록, 비속어나 편견이 없는 대화 데이터를 찾아, 이를 바탕으로 딥러닝 모델링을 통해 챗봇을 만들 수 있는 충분한 성능의 모델을 만들어 이를 바탕으로 감정 교류형 챗봇을 만들 수 있는지를 확인해 본다. 모델의 구현을 위해 Transformer가 세상에 처음 소개된 논문인 [Google Brain, 2016, "Attention is all you need"](https://arxiv.org/abs/1706.03762)를 참조하였다.

**관련 블로그**: [Transformer를 구현하기(함수형(Functional) API편)
](https://conanmoon.medium.com/%EB%8D%B0%EC%9D%B4%ED%84%B0-%EA%B3%BC%ED%95%99-%EC%9C%A0%EB%A7%9D%EC%A3%BC%EC%9D%98-%EB%A7%A4%EC%9D%BC-%EA%B8%80%EC%93%B0%EA%B8%B0-%EC%BA%A1%EC%8A%A4%ED%86%A4-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-2%EC%A3%BC%EC%B0%A8-1c83a14f7155)

## 주요 필요 모듈
아래 모듈들은 해당 프로젝트 노트북 파일을 구동하는데 필요한 외부 모듈중 일부로써, 설치가 필요한 모든 모듈들은 Requirements.txt 파일에서 찾을 수 있습니다.

- WordCloud=1.8.1
- transformers==4.3.3
- tensorflow==2.4.1
- tensorflow-datasets==4.2.0
- plotly==4.14.3

위 모든 모듈들은 프로젝트 노트북 파일 맨 상단에 "0.필요한 Dependencies" 부분을 실행하면 설치할 수 있습니다.

```
# 필요한 Dependencies 설치
import urllib.request
!pip install WordCloud # WordCloud 설치 
!pip install transformers # Transformers 설치
!pip install tensorflow # tensorflow 업데이트
!pip install plotly # plotly 업데이트
!pip install tensorflow-datasets # Tensorflow Datasets 설치
urllib.request.urlretrieve("http://macsplex.com/?module=file&act=procFileDownload&file_srl=2851&sid=ea4a36b12467c4446c21e70762c7d10f&module_srl=2822g", filename="AppleGothic.ttf") # 한글폰트설치
```

## 파이썬 버전
- Google Colab: Python version 3.6.9
- Jupyter Notebook: Python version 3.7.9

## 컴퓨터 사양
2019 MacBook Pro 기준 아래의 스펙에서 구동하였습니다.
- GPU: NVIDIATesla T4
- CPU: 1.4 GHz Quad-Core Intel Core i5
- Memory: 8 GB 2133 MHz LPDDR3

## 파일 설명:
- AppleGothic.ttf: 애플 고딕체 폰트 파일로써, WordCloud활용시 사용됩니다.
- Chatbot-data_master: [Chatbot_data_for_Korean v1.0](https://github.com/songys/Chatbot_data) - 한국어 챗봇 데이터 (ChatbotData .csv) 포함
- Requirments.txt: 해당 챗봇 모델을 구현하기 위해 필요한 모든 Dependencies들 포함
- 카카오톡 감정 교류형 챗봇을 만들기 위한 Transformer 모델링 - 문승태 - 최종본.ipynb: 챗봇 모델을 구현한 과정을 보여주는 프로젝트 Jupyter 노트북 파일 
