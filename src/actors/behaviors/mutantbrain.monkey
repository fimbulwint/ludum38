Strict

Import actors.actor
Import actors.behaviors.behavior
Import actors.behaviors.mobbrainbase

Class MutantBrain Extends MobBrainBase

	Field mutantType:String

	Method New(type:String, actor:Actor, survivors:Survivor[])
		Super.New(actor, survivors)
		mutantType = type
	End Method
	
	Method Update:Void()
		Super.Update()

		If (actor.hp > 0.0)
			If (target = Null Or target.hp < 0.0)
				SelectNewTarget()
			End If
		End If
	End Method	
End Class