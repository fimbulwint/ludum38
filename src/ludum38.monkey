Strict


Import graphics.animator
Import graphics.assets
Import graphics.screen
Import lifecycleaware
Import mojo2 
Import sound.dj
Import scenes.game
Import scenes.scene
Import system.time
Import world.ground
Import world.levelmarker
Import world.train
Import world.world
Import world.worldmap


Class Ludum38 Extends App
	Field screen:Canvas
	Field currentScene:Scene

	Method OnCreate:Int()
		screen = New Canvas()
		screen.SetProjection2d(0.0, Screen.Width, 0.0, Screen.Height)
		Local assets:Assets = Assets.instance ' init
		Animator.Initialize()
		
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
		
		currentScene.Update()
		
		Return 0
	End Method
 
	Method OnRender:Int()
		screen.Clear(0.1, 0.1, 0.4)
		currentScene.Draw(screen)
		screen.Flush()
		Return 0
	End Method
End Class


Function Main:Int()
	New Ludum38()
	Return 0
End Function