# Twitter Web Application

## Purpose: 
This Twitter Web Application takes "tweepy" API to get data of certain allowed users, stores their information in a remote database. It also performs addition of new users to the database, deletion of existing users in the database, update of existing user information, and predicts the owner of a random tweet text among the two users based on a Logistic Regression model.  

**This app is published via Heroku, in the following link: [moon-twitty-app](https://moon-twitty-app.herokuapp.com/)**

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
