Rust-Idris-Fs
=============

An attempt at writing a C library in Rust that can be called from Idris  

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

### Why Rust & Idris?

Rust & Idris can both compile to binaries.  
End users usually do not care how you make them.  
It also matters how much fun you will have writing it.  
Some things are easy to write in Rust that are hard in Idris and vice versa.  

The biggest advantages of Idris over Rust is:

 - A nice interactive REPL environment
 - A simpler type system with simpler rules

The biggest advantages of Rust over Idris is:

 - Easy to write imperative low level code
 - Backed by Mozilla with a fast growing community

If you like to write code in Idris, you will find lack of many libraries.  
Writing C libraries in C/C++ is hard and unsafe.  
Rust is a better language for this.  

Together they have the advantages:

 - Easy to write code that works
 - Rapid prototyping
 - Cross platform development
 - Native compiling
 - Harder to shoot yourself in the foot.

## Goals

- To prove that a file system library written in Rust can be called from Idris.  
- Linux and OSX support

## Non-Goals

- To build a feature complete library to ship with Idris (this is just an experiment)
- Windows support
