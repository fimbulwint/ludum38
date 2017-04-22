Strict

Import mojo2
Import actors.behaviors.behavior

Class Actor

	Field behavior:Behavior
	
	Method New()
	End Method
	
	Method Update():Void
		behavior.Update()
	End Method
	
	Method Draw(canvas:Canvas):Void
	End Method

End Class