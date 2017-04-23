Strict

Import actors.actor
Import actors.behaviors.behavior

Class MutantBrain Implements Behavior

	Field mutantType:String
	Field actor:Actor

	Method New(type:String, actor:Actor)
		mutantType = type
		Self.actor = actor
	End Method
	
	Method Update:Void()
	
	End Method
End Class