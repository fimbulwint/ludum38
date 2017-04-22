Strict


Import mojo2 
Import sound.dj
Import scenes.game
Import scenes.scene
Import system.time
Import world.world



Class Ludum38 Extends App
	Field screen:Canvas
	Const CanvasWidth:Float = 1024.0
	Const CanvasHeight:Float = 768.0

	Field currentScene:Scene

	Method OnCreate:Int()
		screen = New Canvas()
		screen.SetProjection2d(0.0, CanvasWidth, 0.0, CanvasHeight)
	
		Time.instance.Update()
		currentScene = New Game()
		Return 0
	End Method

	Method OnClose:Int()
		currentScene.Finish()
		currentScene = Null
		Return 0
	End Method
	
	Method OnUpdate:Int()
		Time.instance.Update()
		
		Local sceneResult:String = currentScene.GetSceneResult()
		Select (sceneResult)
			Case Scene.STILL_CURRENT_SCENE
			Case Scene.RESULT_END
				currentScene.Finish()
				'for now nothing else
		End Select
		
		currentScene.OnUpdate()
		
		Return 0
	End Method
 
	Method OnRender:Int()
		screen.Clear(1.0, 0.0, 0.0)
		currentScene.OnRender(screen)
		
		Return 0
	End Method
End Class


Function Main:Int()
	New Ludum38()
	Return 0
End Function