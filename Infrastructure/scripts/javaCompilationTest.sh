#!/bin/bash
# Execution of basic program to demonstrate successful configuration management
echo 'class HelloWorld{
    public static void main(String args[]){
     for(int i=0; i<3; i++){
     System.out.println("Hello World");
     }
  }
}' > HelloWorld.java

# Compilation of the program
javac HelloWorld.java

# Execution of compiled Java code
java HelloWorld
echo '\n'

# Java SDK version
java --version

# Java compiler version
javac --version