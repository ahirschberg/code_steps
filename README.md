# What this is

This project aims to give anyone interested in teaching Computer Science concepts the tools to do so in an effective and interactive way.
An example of what the user might see while going through a lesson:

![app lesson screen](http://i.imgur.com/5j8lHHl.png)

# Getting the project

This project is written in Dart, with Angular 2. Unless you're interested in contributing to the frontend app itself, **you don't need the Dart SDK installed**. Instead, use a precompiled-to-js version, which can be gotten by [cloning or downloading the master-js branch](https://github.com/ahirschberg/code_steps/tree/master-js).

### Dependencies:
* **ruby** 2.2 or above
* **bundler** gem

### Installation:
Run `make install` to run the setup commands.

# Writing your own tutorials

Tutorials are written in the text editor of your choice, and are packaged in directories in the `lessons/` folder.

A lesson folder consists of two files:

1. code.\* - this can have any extension, for example code.java or code.py. The code file allows for special highlight regions to be defined and referenced within the tutorial explanation.

2. steps.md - this is where the tutorial explanation is defined. It is written in markdown, with a few extra syntax features.

##### Example *code.py*
```python
#~    |     a      |
print("Hello world.");
```
##### Example *steps.md*

```markdown
#step
# Python basics
To the right is a simple python program. `print` is a piece of code that displays a line of text in the program's console.

#step { spotlight: [a] }
The highlighted portion of the code is an argument being passed to the print statement.
```

##### Note: if you have ideas on how to improve the lesson creation tools or syntax, please [create an issue!](https://github.com/ahirschberg/code_steps/issues)

# Building your lesson
In order to load lessons into the app, they first need to be put into a format that the app can understand. Run `make lessons` to compile all lessons to JSON format.

# Viewing your lesson
To view the lesson you've created within the app, open the `web/index.html` file or run a local webserver ([simple python example](http://www.linuxjournal.com/content/tech-tip-really-simple-http-server-python))
