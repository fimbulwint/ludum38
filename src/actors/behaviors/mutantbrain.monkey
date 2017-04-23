Strict

Import actors.actor
Import actors.behaviors.behavior

Class MutantBrain Implements Behavior

	Field mutantType:String
	Field actor:Actor
	Field survivors:Survivor[]

	Method New(type:String, actor:Actor, survivors:Survivor[])
		mutantType = type
		Self.actor = actor
		Self.survivors = survivors
	End Method
	
	Method Update:Void()
	
	End Method
End Class