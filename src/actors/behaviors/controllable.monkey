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
		owningActor.movingLeft = Bool(KeyDown(KEY_A))
		owningActor.movingRight = Bool(KeyDown(KEY_D))
		owningActor.punching = Bool(KeyDown(KEY_O))
	End Method

End Class