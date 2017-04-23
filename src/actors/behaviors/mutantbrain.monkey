Strict

Import actors.actor
Import actors.behaviors.behavior
Import actors.behaviors.mobbrainbase

Class MutantBrain Extends MobBrainBase
	Const JUMP_FACTOR:Float = 0.3
	Const STOP_DISTANCE:Float = 30.0

	Field mutantType:String

	Method New(type:String, actor:Actor, survivors:Survivor[])
		Super.New(actor, survivors)
		mutantType = type
	End Method
	
	Method ApplySeekAndDestroy:Void()
		Super.ApplySeekAndDestroy()
		If (objective = OBJ_SEEK_AND_DESTROY And actor.IsOnTrain())
			Local targetOffset:Float = target.x - actor.x
			If (Abs(targetOffset) < STOP_DISTANCE)
			Else If (targetOffset > 0.0)
				actor.movingRight = True
			Else
				actor.movingLeft = True
			EndIf If
			
			If (ShouldJumpOnPlayer(targetOffset))
				actor.jumping = True
			End If
		End If
	End Method
	
	Method ShouldJumpOnPlayer:Bool(targetOffset:Float)
		' chances are inversely proportional to the distance towards player, multiplied by a factor
		Local chancesIn1000:Float = (1000.0 - Abs(targetOffset)) * JUMP_FACTOR
		Print(chancesIn1000)
		Local result:Float = Rnd(0.0, 1000.0)
		Return (result < chancesIn1000)
	End Method
End Class