Strict

Import mojo2
Import actors.actor

Class ActorEffects

	Const PUSH_DURATION:Int = 600

	Function PushActorForward:Void(actor:Actor, impactStrength:Float)
		Timer.addTimer(New Pushed(actor))
		actor.speedX += impactStrength
		If (actor.IsAlive() And actor.IsOnTrain())
			actor.y -= 0.001
			actor.speedY = -150
		EndIf
	End Function
	
End Class

Class Pushed Extends Timer Implements Callback

	Field actor:Actor
	
	Method New(actor:Actor)
		Super.New(ActorEffects.PUSH_DURATION, Self)
		Self.actor = actor
		Self.actor.attributes.beingPushed = True
	End
	
	Method Call:Void()
		actor.attributes.beingPushed = False
	End

End