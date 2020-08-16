<h1> Word Analyzer <h2>

<h2> Description </h2>

This web service takes a plain text file input (.txt file), to extract the text from it, splits each sentence within the text contents into a single word, counts how many times each word appeared in the document, and generates graph and Word Cloud to visually depict the processed data.

This project is part of my personal project for Natural Language Processing (NLP), and will be upgraded in the future for improved features over time. The results would be displayed in the descending order of word frequency, which shows the count of each word appeared on the entire text.

The web client part is developed in JavaScript with jQuery, Bootstrap, and libraries from ChartJS.com and libraries for Word Cloud. The server part is developed in Python 3, with the help of Flask libraries. The database used is MongoDB. This work is published using Amazon Web Services.

The back-end is taken care of by "app.py" Python 3 script, and the front-end is responsible by "word_analyzer.html" JavaScript file under "templates" folder.

<h3> Files used: "app.py" and "templates/word_analyzer.html" </h3>
<h3> Data to be used: please use "edgar ellen poe works.txt" upon running "app.py" </h3>

<h4> Important: please install Flask and PyMongo packages in order to run this script, and make sure that you have a proper environment to setup to interpret the python 3 script.</h4>
