Strict

Import graphics.screen
Import lifecycleaware
Import mojo2

Class Lifebar Extends LifecycleAware
	Const GROUND_HEIGHT:Float = Screen.HEIGHT - 165.0
	Const GROUND_REBOUND_SPEED_MIN:Float = 75.0
	Const GROUND_REBOUND_SPEED_MAX:Float = 125.0
	
	Method Update:Void(worldState:WorldState)
		'empty for now
	End Method

	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(0.0, 0.6, 0.0)
		canvas.DrawRect(100.0, 100.0, 1000.0, 100.0)
		canvas.PopMatrix()
	End Method

End Class