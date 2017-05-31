Strict

Import mojo2
Import scenes.scene
Import system.time
Import graphics.assets
Import graphics.screen

Class GameOver Implements Scene

	Field image:Image = Assets.instance.graphics.Get(Assets.GFX_GAME_OVER)
	
	Const FADE_SPEED:Float = 1.0
	Const DIMMING_SPEED:Float = 0.5
	Field color:Float = 0.0
	Field colorOffset:Float = 0.25
	
	Field fadingIn:Bool = True
	
	Method Update:Void()
		If (fadingIn)
			color += FADE_SPEED * Time.instance.getDeltaInSecs()
			If (color > 1.0)
				color = 1.0
				fadingIn = False
			End If
		Else
			colorOffset += DIMMING_SPEED * Time.instance.getDeltaInSecs()
			If (colorOffset > 0.25) Then colorOffset -= 0.5
			color = 0.75 + Abs(colorOffset)
		End If
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(color, color, color)
		canvas.DrawImage(image, 0.0, 0.0)
		canvas.PopMatrix()
	End Method
	
	Method GetSceneResult:String()
		If (KeyHit(KEY_SPACE) Or KeyHit(KEY_ENTER) Or KeyHit(KEY_ESCAPE))
			Return Scene.RESULT_END
		End If
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
	End Method
	
End Class