Rust-Idris-Fs
=============

An attempt at writing a C library in Rust that can be called from Idris  

# About Rust-Idris-Fs

This is a project to demonstrate implementation of a few file system functions.  
At the moment these features lack in Idris, but is supported in Rust.  
'Fs' stands for file system.  

Issues labeled with `Information` contains useful information to solve problems associated with writing cross language libraries.  
You can use the search bar at the top to quickly look up a topic.

So far the progress made is [Calling a simple function written in Rust from Idris](https://github.com/bvssvni/rust-idris-fs/issues/2).  
To do this you need to [Build Idris with FFI support](https://github.com/bvssvni/rust-idris-fs/issues/3).  

## Goals

- To prove that a file system library written in Rust can be called from Idris.  
- Linux and OSX support

## Non-Goals

- To build a feature complete library to ship with Idris (this is just an experiment)
- Windows support

##About Idris & Rust

Rust is a low level language but with a rapidly growing number of available libraries.  
Idris is a high level language with dependent types and a REPL environment.  

Both are languages focused on safety and practicality.  
It is possible to combine the best of both worlds?  

### Why Idris?

Programming languages are getting more and more complicated.  
The type system in a language often evolves into a language by itself.  
Idris is a research language which goal is to unify the language of the type system with what it does.  
As a consequence it feels very lightweight, but powerful.  

 - Less context switching
 - Interactive REPL environment
 - Easy to use with C libraries

### Why Rust?

Systems programming often requires precise control over performance.  
Most languages were designed for single thread execution, making them less adaptive to new hardware.  
Rust allows you to write safe concurrent code with optional garbage collection.  
The language allows one to have more choices and aggressively optimize for a special use case.  

 - Statically analysis of pointers
 - Cross platform
 - Easy to use/write C libraries

### Why Idris & Rust?

Together they have the advantages:

 - Easy to write code that works
 - Rapid prototyping
 - Cross platform development
 - Native compiling
 - Harder to shoot yourself in the foot.
