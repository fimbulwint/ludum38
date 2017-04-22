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
		owningActor.jumping = Bool(KeyDown(KEY_W))
		owningActor.movingLeft = Bool(KeyDown(KEY_LEFT))
		owningActor.movingRight = Bool(KeyDown(KEY_RIGHT))
	End Method

End Class