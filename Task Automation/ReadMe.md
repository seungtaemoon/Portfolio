# Task Automation Project

## Objective: to automate entering medical data to a target software

## Background:
> The hematology clinical trials require continuous monitoring and updating of the trials such as concomitant medication information

> Traditionally, the clinical researchers prepared the clinical data in MS Word format, and then manually entered it on to the data management software

> The work can be tedious and repetitive, which can be automated

## The big picture 

## Used tools:
* Viedoc: one of the widely used clinical data management web software
* Jupyter Notebook: to develop automation script

## Major technology
* `selenium`: to access the web components written in JavaScripts
* `pyautogui`: to allow control of keyboard and mouse inputs by software to enable interaction between different applications
* `pygetwindow`: to allow obtaining information from the windows of the controlling application
* `python-docx`: to import data from MS Word(doc) file
* `Pandas`: to convert the imported data from doc file into Pandas Dataframe for convenient handling of the data

## Files:
* `test.doc`: the original data written in MS Word
* `concomitant medication`: the automation script to enter concomitant medication information from the doc file
