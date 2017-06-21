Strict

Import mojo2
Import actors.behaviors.behavior
Import actors.actor

Class Controllable Implements Behavior

	Field owningActor:Actor

	Method New(actor:Actor)
		Self.owningActor = actor
	End Method
	
	Method Update:Void()
		owningActor.jumping = Bool(KeyDown(KEY_W)) Or Bool(KeyDown(KEY_UP))
		owningActor.movingLeft = Bool(KeyDown(KEY_A)) Or Bool(KeyDown(KEY_LEFT))
		owningActor.movingRight = Bool(KeyDown(KEY_D)) Or Bool(KeyDown(KEY_RIGHT))
		owningActor.wantsToPunch = Bool(KeyDown(KEY_O)) Or Bool(KeyDown(KEY_SPACE))
	End Method

End Class