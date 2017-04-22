Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor

Class Survivor Extends Actor

	Method New()
		behavior = New Controllable()
	End Method
	
	Method Update:Void()
		behavior.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
	End Method

End Class