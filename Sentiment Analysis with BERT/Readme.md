
# 프로젝트 소개

## 요약

우리나라에서는 대표적으로 동영상 OTT서비스인 왓챠(Watcha)같은 곳이 대표적으로 감정 분석(Sentiment Analysis)을 활용하는 회사라 할 수 있다. 왓차는 사용자의 기호에따라, 사용자가 즐겨 찾는 타입의 영화 중 가장 인기있는 영화를 추천하는 서비스를 제공하는데, 바로 이런 목적을 위해 자연어처리 감정분석 기법을 활용할 수 있다. 또한, 사람들이 좋아하는 영화들이 가진 키워드 등의 정보를 찾아내, 좀 더 최적화된 서비스를 제공하는데 활용하기도 한다. 

이 프로젝트에서는 네이버 데이터를 활용하여, 영화에 대한 유저들의 감정을 분석한다. 왓챠의 영화리뷰 데이터를 직접 얻을 수 있다면 좋았겠으나, 그렇게 할 수 없어 네이버 영화 리뷰 데이터를 왓챠의 내부 유저 콘텐츠 리뷰 데이터로 간주하고 진행하였다. 왓챠의 어떤 영화들이 평이 가장 좋은지, 그 영화들의 공통점이 무엇인지 찾아본다. 감정 분석을 위해, 자연어처리의 가장 최신 기술인 Transformer타입의 BERT 모델을 사용하여 모델링하였으며, 사용한 데이터의 링크는 다음과 같다. [네이버 영화리뷰 데이터](https://github.com/e9t/nsmc/)

## 유의 사항

### Google Colab

노트북 구동 전 처음 두 줄을 실행해줍니다. (WordCloud 및 transformers 설치)

```
!pip install wordcloud
!pip install transformers
```


### Jupyter Notebook

노트북 구동 전, requirements.txt에 있는 프로그램을 설치합니다.

* 해당 프로젝트를 다운 받은 후 아래의 명령어를 이용하여 필요한 패키지들을 설치합니다.

```
# 개별적으로 설치해 주어야할 패키지
conda install -c intel mkl_fft==1.0.15
conda install -c intel mkl_random==1.1
conda install -c intel mkl-service==2.3.0
pip install tbb4py

# Requirements.txt에 있는 모든 패키지 설치
pip install -r requirements_jupyter.txt
```

* 만약 transformers 모듈 사용에 문제가 있다면, 아래 명령어를 통해 transformers 모듈을 설치해줍니다.
```
conda install -c huggingface transformers
```

## 사양

### 파이썬 버전
* Google Colab: Python version 3.6.9
* Jupyter Notebook: Python version 3.7.9

### 컴퓨터 사양

2019 MacBook Pro 기준 아래의 스펙에서 구동하였습니다.
* GPU: NVIDIATesla T4
* CPU: 1.4 GHz Quad-Core Intel Core i5
* Memory: 8 GB 2133 MHz LPDDR3

## 파일 설명

* AppleGothic.ttf: 애플 고딕체 폰트 파일로써, WordCloud활용시 사용됩니다.
* ratings_train.txt: train 데이터
* ratings_test.txt: test 데이터
* requirements.txt: 프로그램을 구동하는데 필요한 패키지 정보가 담긴 파일
* result: fine-tuning된 모델이 저장되는 폴더
