class_name Decision extends RefCounted

## Sends the results of the decision back
signal decision_made

## The prompt to display in an outcome
var prompt: String

## if true, decision has been made and can't be changed
var _decision_made: bool = false
