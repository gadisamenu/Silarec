# Silarec
Mobile application that makes it simple for users to understand American Sign Language without the involvement of a third party.

The application translates sign language from a video to text written in English so that the user is able to understand without the need to be familiar with sign language.
***
*  Translates Sign Language from recorded video 

* Real-time sign language recognition directly from camera recording
***
![*Silarec*](https://drive.google.com/file/d/19vtmQ0CfbWNBMQGOM1mBtFZiKsG-L2lq/view?usp=sharing)

# Getting Started
## Tools used
* flutter: for application development 
* Tensorflow: for model training 
* mediaPipe: for prepocessing of the frames
## Datasset
* The dataset is published on a website  Word Level American Sign Language(WLASL)
* There are 2000 common different words with multiple videos for each
* It is already separeted into training and test data

## Feature Extraction
The frames are processed and the landmarks of hand and face is extracted from the image using mediaPipe library.

## Algorithm
### Type of problem: Sequence Classification

* Sequence classification problem involves predicting a class label for a given input sequence.

* The objective is to build a classification model using a labeled dataset so that the model can be used to predict the class label of an unseen sequence

 * ML Algorithm used: Deep Neural Network


## Model Selection(Hyperparameter tuning)
* To get the best combination of hyperparameters the Bayesian optimization technique is used