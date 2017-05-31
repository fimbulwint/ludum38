Strict

Import actors.actor
Import actors.behaviors.behavior
Import actors.behaviors.mobbrainbase

Class MutantBrain Extends MobBrainBase
	Const JUMP_FACTOR:Float = 0.025
	Const NEAR_DISTANCE:Float = 30.0
	Const TARGET_OVERHEAD_DISTANCE:Float = 40.0

	Field mutantType:String

	Method New(type:String, actor:Actor, survivors:Survivor[])
		Super.New(actor, survivors)
		mutantType = type
	End Method
	
	Method ApplySeekAndDestroy:Void()
		Super.ApplySeekAndDestroy()
		If (objective = OBJ_SEEK_AND_DESTROY And actor.IsOnTrain())
			Local targetOffset:Float = target.x - actor.x
			If (Abs(targetOffset) < NEAR_DISTANCE)
				ApplyNearBehavior(targetOffset)
			Else If (targetOffset > 0.0)
				actor.movingRight = True
			Else
				actor.movingLeft = True
			EndIf
			
			If (ShouldJumpOnPlayer(targetOffset))
				actor.jumping = True
			End If
		End If
	End Method
	
	Method ShouldJumpOnPlayer:Bool(targetOffset:Float)
		' chances are inversely proportional to the distance towards player, multiplied by a factor
		Local chancesIn1000:Float = (1000.0 - Abs(targetOffset)) * JUMP_FACTOR
		Local result:Float = Rnd(0.0, 1000.0)
		Return (result < chancesIn1000)
	End Method
	
	Method ApplyNearBehavior:Void(targetOffset:Float)
		' default
		If (actor.y - target.y >= TARGET_OVERHEAD_DISTANCE)
			' target is overhead, by default just wait until it comes in attack range again
		Else
			' jump to target
			If (targetOffset > 0.0)
				actor.movingRight = True
			Else
				actor.movingLeft = True
			EndIf
			actor.jumping = True
		End If
	End Method
End Class