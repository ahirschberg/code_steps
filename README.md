# What this is

This project aims to give anyone interested in teaching Computer Science concepts the tools to do so in an effective and interactive way.
An example of what the user might see while going through a lesson:
![app lesson screen](http://i.imgur.com/5j8lHHl.png)

# Getting the project 

This project is written in Dart, with Angular 2. Unless you're interested in contributing to the frontend app itself, you don't need dart installed. Instead, use a precompiled-to-js version, which can be gotten by pulling the [gh-pages branch](https://github.com/ahirschberg/code_steps/tree/gh-pages) or [downloading a zip of the branch](https://github.com/ahirschberg/code_steps/archive/gh-pages.zip).

# Writing your own tutorials

#### Note: This portion of the tutorial is incomplete. See [this issue](https://github.com/ahirschberg/code_steps/issues/12) for details.

### Dependencies:
* **ruby** 2.0 or above
* **redcarpet** gem - can be gotten with `gem install redcarpet`

Tutorials are written in the text editor of your choice, and consist of two files placed in the `lessons/your-lesson-name/` directory

1. *code.\** - this can have any extension, for example code.java or code.py. The code file allows for special highlight regions to be defined and referenced within the tutorial explanation.

2. *steps.md* - this is where the tutorial explanation is defined. It is written in markdown, with a few extra syntax features.

##### Example *code.py*
```python
#~    |     a      |
print("Hello world.");
```
##### Example *steps.md*
```markdown
# { step: 1 }
# Python basics
To the right is a simple python program. `print` is a piece of code that displays a line of text in the program's console.

# { step: 2, spotlight: [a] }
The highlighted portion of the code is an argument being passed to the print statement.
```

# Building your lesson
In order to load lessons into the app, they first need to be built to json by running `make`. This will compile all folders in the `lessons/` directory and place lesson json files in the `static/` directory, where they can be loaded by the app by name in the text box located at the bottom of the app.
