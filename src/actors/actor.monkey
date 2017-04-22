Strict

Import mojo2 

Class Actor

	Field behavior:Behavior
	
	Method New()
	End Method
	
	Method Update():Void
		behavior.Update()
	End Method
	
	Method Draw(canvas:Canvas):Void
		behavior.Draw(canvas)
	End Method

End Class

Interface Behavior
	
	Method Update():Void
	
	Method Draw(canvas:Canvas):Void

End