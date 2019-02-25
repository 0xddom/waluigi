# Waluigi

[![Gem Version](https://badge.fury.io/rb/waluigi.svg)](https://badge.fury.io/rb/waluigi)
[![PyPI version](https://badge.fury.io/py/waluigi-facade.svg)](https://badge.fury.io/py/waluigi-facade)

With the power of pycall and some metaprogramming magic is possible to facade a ruby class into a luigi task. Not everything works, but looks promising.

## Instalation

Waluigi is divided into 2 packages, a ruby gem and a python egg. You need to install both in order to be able to use waluigi.

    gem install waluigi
    pip install waluigi-facade

## Usage

Write a Tasksfile like the one provided here, then use the `waluigi` binary for running the tasks. The binary will take the arguments and will pass them verbatim to luigi.

For example:

    waluigi MyTask --local-scheduler

## What works

- Executing the run method
- Declaring outputs defined in Python code
- Declaring requirements programmed either in Ruby or Python
- Parameters declaration in Ruby
- Getting information from the Python side (output(), input(), parameters, etc)

## What doesn't

- Utility classes: WrapperTask, ExternalTask, etc
