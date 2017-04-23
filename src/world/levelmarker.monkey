Strict

Import graphics.assets
Import graphics.screen
Import lifecycleaware
Import mojo2
Import system.time
Import world.worldmap

Class LevelMarker Extends LifecycleAware
	Const INITIAL_X:Float = 25.0
	Const Y:Float = Screen.Height - 25.0
	Const CHAR_SEPARATION_X:Float = 26.0
	Const SHINE_SPEED:Float = 1.0
	
	Field font:Font = Assets.instance.fonts.Get(Assets.FNT_BOYCOTT)
	Field worldMap:WorldMap
	Field levelString:String
	
	Field shinePower:Float = -1.0
	
	Method New(worldMap:WorldMap)
		Self.worldMap = worldMap
	End Method
	
	Method Update:Void(worldState:WorldState)
		Local delta:Float = Time.instance.lastFrame 
		levelString = String(worldMap.level)
		'levelString = "3578"
		shinePower += (SHINE_SPEED * delta) / 1000.0
		If (shinePower > 1.0)
			shinePower -= 2.0
		End If
	End Method

	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetFont(font)
		canvas.SetColor(1.0, 1.0, 1.0)
		canvas.SetBlendMode(BlendMode.Additive)
		Local power:Float = Abs(shinePower)
		Local x:Float = INITIAL_X
		
		For Local charPos:Int = 0 To levelString.Length - 1
			Local char:String = levelString[charPos..charPos + 1]
			canvas.SetAlpha(0.15 * power)
			canvas.DrawText(char, x + Rnd(-4.0, 4.0), Y + Rnd(-4.0, 4.0), 0.0, 1.0)
			canvas.SetAlpha(0.25 * power)
			canvas.DrawText(char, x + Rnd(-2.0, 2.0), Y + Rnd(-2.0, 2.0), 0.0, 1.0)
			canvas.SetAlpha(1.0)
			canvas.DrawText(char, x + Rnd(-0.5, 0.5), Y + Rnd(-0.5, 0.5), 0.0, 1.0)
			x += CHAR_SEPARATION_X
		End For
		canvas.PopMatrix()
	End Method
End Class