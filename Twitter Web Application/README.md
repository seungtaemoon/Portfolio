# Twitter Web Application

## Purpose: 
This Twitter Web Application takes "tweepy" API to get data of certain allowed users, stores their information in a remote database. It also performs addition of new users to the database, deletion of existing users in the database, update of existing user information, and predicts the owner of a random tweet text among the two users based on a Logistic Regression model.  

**This app is published via Heroku, in the following link: [moon-twitty-app](https://moon-twitty-app.herokuapp.com/)**

Blog(Korean): [Flask라는 이름의 교관](https://conanmoon.medium.com/%EB%8D%B0%EC%9D%B4%ED%84%B0%EA%B3%BC%ED%95%99-%EC%9C%A0%EB%A7%9D%EC%A3%BC%EC%9D%98-%EB%A7%A4%EC%9D%BC-%EA%B8%80%EC%93%B0%EA%B8%B0-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-3-4-3d9571c281f0)

## Modules used:
- Flask
- flask_sqlalchemy
- sklearn
- tweepy
- embedding_as_service_client

## Environments:
- HTML
- SQL
- Python

## Database:
- PostgreSQL

## Publication:
- Heroku

## Instructions:
- Please refer to "twitty.py" for the Python code
- Please refer to "templates" folder for the HTML templates used
- Please refer to "Migration" folder for database information
- Please refer to "requirements.txt" for the associated python modules
- Please refer to "Procfile" for the gunicorn assignment
- Please refer to "user_tweet.png" for the schema of the database
