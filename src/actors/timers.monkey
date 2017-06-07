Strict

Import mojo2
Import utils.timer
Import actors.actor

Class DefaultRecoveringTimeout Extends Timer
	
	Method New(actor:Actor)
		Super.New(500, New RemoveRecoveringEffect(actor))
	End

End

Class RemoveRecoveringEffect Implements Callback

	Field actor:Actor
	
	Method New(actor:Actor)
		Self.actor = actor
	End Method
	
	Method Call:Void()
		actor.attributes.state = State.DEFAULT_STATE
	End Method

End Class