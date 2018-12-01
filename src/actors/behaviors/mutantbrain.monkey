Strict

Import actors.actor
Import actors.behaviors.behavior
Import actors.behaviors.mobbrainbase
Import utils.geometry

Class MutantBrain Extends MobBrainBase

	Const OBJ_DEATH_PLUNGE:String = "DEATH_PLUNGE"

	Const JUMP_FACTOR:Float = 0.025
	Const NEAR_DISTANCE:Float = 30.0
	Const TARGET_OVERHEAD_DISTANCE:Float = 40.0
	
	Const ORANGUSAND_PLUNGE_SPEED:Float = 500

	Method New(actor:Actor, survivors:Survivor[])
		Super.New(actor, survivors)
	End Method
	
	Method Update:Void()
		Super.Update()
		
		Local mutant:Mutant = Mutant(actor)
		If (mutant <> Null And mutant.IsAlive() And mutant.type = Mutant.ORANGUSAND)
			Select(objective)
				Case OBJ_DEATH_PLUNGE
					' Nothing to do, mutant keeps plunging until it dies
				Default
					If (ShouldPlungeOntoPlayer(mutant)) Then StartPlungeToDeath(mutant)
			End Select
		End If
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
	
	Method ShouldPlungeOntoPlayer:Bool(orangusand:Mutant)
		' Somehow target becomes null when the survivor dies. Not sure why
		If (target = Null) Then Return False
	
		Return Abs(orangusand.speedY) < 5 And ' Close to peak
			target.y - orangusand.y > 2 * target.GetBoxHeight() And ' Sufficiently high above the target
			Rnd(0.0, 1.0) < 0.4 ' Adjust chance to trigger
	End Method
	
	Method StartPlungeToDeath:Void(orangusand:Mutant)
		objective = OBJ_DEATH_PLUNGE
		orangusand.isPlunging = True
		
		Local plungeDirection:Float[] = Geometry.getDirection(orangusand, target)
		orangusand.plungeSpeed =[plungeDirection[0] * ORANGUSAND_PLUNGE_SPEED, plungeDirection[1] * ORANGUSAND_PLUNGE_SPEED]
	End Method
	
End Class