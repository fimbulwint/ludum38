Strict


Import actors.behaviors.behavior
Import actors.behaviors.controllable
Import actors.behaviors.mutantbrain
Import actors.actor
Import actors.mutant
Import actors.survivor
Import graphics.animator
Import graphics.assets
Import graphics.screen
Import lifecycleaware
Import mojo2 
Import sound.dj
Import scenes.game
Import scenes.gameover
Import scenes.menu
Import scenes.scene
Import system.time
Import world.background
Import world.ground
Import world.levelmarker
Import world.train
Import world.world
Import world.worldmap
Import utils.timer

Class Ludum38 Extends App

	Field screen:Canvas
	Field currentScene:Scene

	Method OnCreate:Int()
		screen = New Canvas()
		screen.SetProjection2d(0.0, Screen.WIDTH, 0.0, Screen.HEIGHT)
		Local assets:Assets = Assets.instance ' init
		Dj.instance.Init()
		Animator.Initialize()
		Seed = Millisecs()
		Time.instance.Update()
		currentScene = New Menu()
		Return 0
	End Method

	Method OnClose:Int()
		currentScene.Finish()
		currentScene = Null
		Return 0
	End Method
	
	Method OnResume:Int()
		Time.instance.Update()
		Return 0
	End Method
	
	Method OnUpdate:Int()
		Time.instance.Update()
		Dj.instance.Update()
		
		Local sceneResult:String = currentScene.GetSceneResult()
		Select (sceneResult)
			Case Scene.STILL_CURRENT_SCENE
			Case Scene.RESULT_END
				currentScene.Finish()
				If (Game(currentScene) <> Null)
					currentScene = New GameOver()
				Else If (Menu(currentScene) <> Null)
					currentScene = New Game()
				Else If (GameOver(currentScene) <> Null)
					currentScene = New Menu()
				EndIf
		End Select
		
		currentScene.Update()
		Timer.TickTimers()
		
		Return 0
	End Method
 
	Method OnRender:Int()
		screen.Clear(0.2, 0.2, 0.4)
		currentScene.Draw(screen)
		screen.Flush()
		Return 0
	End Method
	
End Class


Function Main:Int()
	New Ludum38()
	Return 0
End Function