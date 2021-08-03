# Reddit data analyzing project
The project is designed to process and analyze Reddit comments data. As input, it takes Reddit comments archive files, and provide analytics, such as:
- list of languages with numbers of messages
- number of messages among sentiment classes 
- top 10 keywords.

## The project consists of the following parts:
- Generator microservice that splits the dataset to reddit comment messages. 
- A microservice that detects a language of a message.
- A microservice that recognizes sentiment class of a message.
- A microservice that generates a keyword list of a message.
- A microservice that generates and exposes HTTP endpoint with statistics.

## High-level design diagram
![image](https://user-images.githubusercontent.com/15198798/128067642-16948ec5-b50a-414a-a076-559c10b21b91.png)

