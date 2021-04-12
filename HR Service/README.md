# 데이터 사이언티스트의 이직을 막기 위해 IT 중소기업 경영자에게 제공할 HR Service

시중의 HR Service를 제공하는 회사들은 기업을 주고객 대상으로 삼아 outsourcing 및 consulting하는 것에 그치고 있다. 그러나 인재 영입 못지 않게 이직을 막는 것 역시 기업 경영자에게 큰 고민이 아닐 수 없다. 기업 경영에 있어 고급 인력 상실은 업무 효율 저하뿐 아니라 기업의 질 낮은 서비스 제공과 맞닿아 있기 때문이다.

과연 외주나 교육 및 조직 개편 등의 기존 consulting만으로 회사의 유능한 인재 이탈을 막을 수 있을까? 가속화된 4차 산업혁명의 물결 속에서 HR Service 산업 역시 새로운 변화와 혁신을 요구 받고 있다. 

데이터 사이언티스트의 이직을 방지하기 위해 UT 중소기업 경영자가 경계해야할 요소는 무엇일까?
HR Service의 새 방향을 제시하기 위해 본 프로젝트는 기획되었다.
**작성자: 김민채(GitHub: https://github.com/inthemingcha/everything_mchae), 문승태(본인)**

## 프로젝트 파일:
- 데이터 사이언티스트의 이직을 막기 위해 IT 중소기업 경영자에게 제공할 HR Service 분석[김민채, 문승태].ipynb: 프로젝트의 모든 분석을 담은 노트북 파일
- aug.csv: 데이터 사이언티스트의 이직 정보를 담은 데이터 파일(출처: [HR Analytics: Job Change Of Data Scientists dataset](https://www.kaggle.com/arashnic/hr-analytics-job-change-of-data-scientists))
- WA_Fn-UseC_-HR-Employee-Attrition.csv: IBM이라는 회사의 직원들의 이직 정보를 담은 데이터 파일(출처: [IBM HR analytics Employee Attrition dataset](https://www.kaggle.com/pavansubhasht/ibm-hr-analytics-attrition-dataset))
- presentation.pptx: 발표영상(presentation.mp4)에 활용한 프레젠테이션 PPT 파일
- presentation.mp4: 프로젝트 발표영상

## 프로젝트 사용법
- 처음 데이터를 불러오는 아래 셀에서, 위 2개의 데이터 파일을 불러오고 나서 모든 셀을 Run하면 됩니다.

```
### load dataset
import pandas as pd

ibm_hr = pd.read_csv('WA_Fn-UseC_-HR-Employee-Attrition.csv')
ds_hr = pd.read_csv('aug.csv')
```

## 필요한 외부 라이브러리
- plotly (버전 4.4.1 이상)

**프로젝트 노트북 파일 맨 위에 있는 아래 코드를 반드시 돌릴 것**
```
# 분석 및 모델링을 위한 플러그인 준비
%%capture
import sys

if 'google.colab' in sys.modules:
  !pip install plotly==4.4.1
```
