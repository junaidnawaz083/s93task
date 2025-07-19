# App Features

## Speech-to-Text

- This app is using speech-to-text package
- User is speaking insted to typing to perform action
- Using speech-to-text package, App is recording user voice and generating text that will be used to perform actions

## LLM

- This app is using Google Generative AI (gemini ai) package to analyze command from speech-to-text package
- LLM model returns a formated json data that includes action, title, oldTitle, description, time and date
- This data is being validated and processed in app

## Database

- To store validated data from LLM, App using sqflite package
- Using sqflite, App is perform CRUD operations.

## How LLM intigration works

- User speaks a command
- App converts speech to text
- This text is sent to the Google Generative AI model
- The LLM analyzes the text and returns a formated json data
- App saves this json result into the local database

## Setup Instructions

- Clone repository
- Get packages using flutter pub get
