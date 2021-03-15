# 카카오톡 감정교류형 챗봇을 만들기 위한 Transformer 자연어처리(NLP) 모델 구현 프로젝트

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
