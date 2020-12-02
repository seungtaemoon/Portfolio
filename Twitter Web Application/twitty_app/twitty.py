from flask import Flask, jsonify, redirect
from flask_sqlalchemy import SQLAlchemy #=> pip install flask-sqlalchemy
from flask_migrate import Migrate #=> pip install flask-migrate
import tweepy #=> pip install tweepy
from flask import Blueprint, render_template, request
import os, pickle
from sklearn.linear_model import LogisticRegression
from embedding_as_service_client import EmbeddingClient
import numpy as np

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = "postgres://yysezmtujabpkl:ac9b856cf13d2a04d7e93ad960efaad31806bbd2d9905281b8130f96a54b4750@ec2-23-20-129-146.compute-1.amazonaws.com:5432/d4g8ojk44ngj0l"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)
migrate = Migrate(app, db)
en = EmbeddingClient(host='54.180.124.154', port=8989)

auth = tweepy.OAuthHandler('yWZn9cji4bdD50NfqOmpHRWqS', 'HsqcrRzCmTwDYSsvyTn38nhURoDjoPap36lnwmdPRSHk4noXrK')
auth.set_access_token('1320589941349388289-kiuupqS0Hd1AoQgfup2JnwT8SiFoH1', 'iW3X44kFdp3bwtTYD47xmI489sNnDEhzHSnUkpyg5P0sJ')

api = tweepy.API(auth)

class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)
    username = db.Column(db.String)
    full_name = db.Column(db.String)
    followers_count = db.Column(db.Integer)
    location = db.Column(db.String)

    def __repr__(self):
        return f"<User {self.user_id} {self.username} {self.full_name} {self.followers_count} {self.location}>"

class Tweet(db.Model):
    __tablename__ = "tweet"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String)
    text = db.Column(db.String)
    embedding = db.Column(db.PickleType)

    def __repr__(self):
        return f"<Tweet {self.username} {self.text} {self.embedding}>"


db.create_all()

def append_to_with_label(to_arr, from_arr, label_arr, label):

    for item in from_arr:
        to_arr.append(item)
        label_arr.append(label)


@app.route('/add', methods=["GET", "POST"])
def add():
    if request.method == "POST":
        try:
            that = request.form.get("username")
            this = api.get_user(screen_name=that)
            user = User(user_id = this.id, username = this.screen_name, full_name = this.name, followers_count = this.followers_count, location = this.location)
            db.session.add(user)
            these = api.user_timeline(screen_name=that)[0]
            tweet = Tweet(username = this.screen_name, text = these.text, embedding = en.encode(texts=[these.text]))  
            db.session.add(tweet)          
            db.session.commit()
            msg = "The new user is now added!"
        except Exception as e:
            db.session.rollback()
            print("Failed to add user")
            print(e)
            msg = "Please enter the valid username"
    users = User.query.all()
    return render_template("add.html", users = users)

@app.route('/delete', methods=["GET", "POST"])
def delete():
    if request.method == "POST":
        try:
            that = request.form.get("username")
            user = User.query.filter(User.username == that).delete()
            tweet = Tweet.query.filter(Tweet.username == that).delete()
            db.session.commit()
            msg = "The new user is now deleted!"
        except Exception as e:
            db.session.rollback()
            print("Failed to delete user")
            print(e)
            msg = "Please enter the valid username"
    users = User.query.all()
    return render_template("delete.html", users = users)

@app.route('/update', methods=["GET", "POST"])
def update():
    if request.method == "POST":
        try:
            old_name = request.form.get("old_name")
            new_name = request.form.get("new_name")
            print(old_name, new_name)
            User.query.filter(User.full_name == old_name).update({'full_name' : new_name})
            print(User.full_name)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            print("Couldn't update the name")
            print(e)
    return render_template("update.html")

@app.route('/predict', methods=["GET", "POST"])
def predict():
    pred = []
    if request.method == "POST":
        try:
            user_1 = request.form.get("user_1")
            user_2 = request.form.get("user_2")
            tweet_1 = api.user_timeline(screen_name=user_1)[0]
            tweet_2 = api.user_timeline(screen_name=user_2)[0]
            X = []
            y = []
            vecs = en.encode(texts=[tweet_1.text])
            vecs2 = en.encode(texts=[tweet_2.text])
            append_to_with_label(X, vecs, y, user_1)
            append_to_with_label(X, vecs2, y, user_2)            
            for_pred = ["안녕하세요"]
            pred_val = en.encode(texts=for_pred)
            classifier = LogisticRegression()
            classifier.fit(X,y)
            prediction = classifier.predict(pred_val)
            print(prediction)
            pred.append(prediction[0])
        except Exception as e:
            db.session.rollback()
            print("Some error occurred. Please try again.")
            print(e)
    return render_template("predict.html", pred = pred)

@app.route('/')
def index():
    data = User.query.all()
    return render_template("index.html", data=data)




if __name__ == "__main__":
    app.run(debug=True)

