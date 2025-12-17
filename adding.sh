#!/bin/bash
echo "please enter the number"
read NUMBER

if [ $(( $NUMBER % 2)) -eq 0 ]; then
echo "the given number is $NUMBER prime number"
else 
echo "the given number is $NUMBER not prime number"
fi