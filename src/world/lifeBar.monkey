Strict

Import actors.survivor
Import lifecycleaware
Import mojo2

Class Lifebar Extends LifecycleAware

 	Field survivorHealth:Float = 1.0

	Method Update:Void(worldState:WorldState)
		survivorHealth = worldState.mainSurvivor.attributes.hp / Survivor.BASE_HP
	End Method

	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(0.5, 0.5, 0.5)
		canvas.DrawRect(10.0, 10.0, 510.0, 20.0)
		canvas.PopMatrix()
	
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(1.0, 0.0, 0.0)
		canvas.DrawRect(15.0, 15.0, 500.0 * survivorHealth, 10.0)
		canvas.PopMatrix()
	End Method

End Class