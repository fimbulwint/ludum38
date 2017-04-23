Strict

Import actors.behaviors.behavior
Import world.train

Class MobBrainBase Implements Behavior 
	Const OBJ_SEEK_AND_DESTROY:String = "SEEK_AND_DESTROY"
	Const OBJ_APPROACH_TRAIN:String = "APPROACH_TRAIN"
	Const OBJ_MOVE_TO_POINT_ON_TRAIN:String ="MOVE_TO_POINT_ON_TRAIN"

	Const TRAIN_X_MIN:Float = Train.TRAIN_START + 80.0
	Const TRAIN_X_MAX:Float = Train.TRAIN_END - 80.0
	
	Field actor:Actor
	Field survivors:Survivor[]
	Field target:Survivor
	
	Field objective:String
	Field objX:Float
	Field approachVectorX:Float ' from left or right, to know when we reached it

	Method New(actor:Actor, survivors:Survivor[])
		Self.actor = actor
		Self.survivors = survivors
	End Method
	
	Method Update:Void()
		If (actor.hp > 0.0)
			actor.movingRight = False
			actor.movingLeft = False
			actor.jumping = False
			Select (objective)
				Case ""
					StartSeekAndDestroy()
				Case OBJ_SEEK_AND_DESTROY
					If (actor.IsOnGround())
						StartApproachTrain()
					Else 
						ApplySeekAndDestroy()
					End If
				Case OBJ_APPROACH_TRAIN
					If (actor.IsOnTrain()) 'obj achieved
						StartSeekAndDestroy()
					Else 
						ApplyApproachTrain()
					End If
				Case OBJ_MOVE_TO_POINT_ON_TRAIN
					If (actor.IsOnGround())
						StartApproachTrain()
					Else
						ApplyMoveToPointOnTrain()
					EndIf
			End Select
		End If
	End Method
	
	Method StartSeekAndDestroy:Void()
		SelectNewTarget()
		objective = OBJ_SEEK_AND_DESTROY
		Print(objective)
	End Method
	
	Method ApplySeekAndDestroy:Void()
		If (target = Null Or target.hp < 0.0)
			SelectNewTarget()
		End If
		If (target = Null) ' no available targets, move to random point
			StartMoveToPointOnTrain()
		End If
		'TODO
	End Method

	Method StartApproachTrain:Void()
		objective = OBJ_APPROACH_TRAIN
		SetObjX(-1.0)
		Print(objective)
	End Method
	
	Method ApplyApproachTrain:Void()
		If (actor.IsOnGround()) 
			If (actor.x < objX)
				If (approachVectorX < 0.0) 'arrived to jump point
					actor.jumping = True
				Else
					actor.movingRight = True
				End If
			Else
				If (approachVectorX > 0.0) 'arrived to jump point
					actor.jumping = True
				Else
					actor.movingLeft = True
				End If
			End If
		Else
		' if not on ground wait for him to fall somewhere
		End If
	End Method

	' -1.0 = random x
	Method StartMoveToPointOnTrain:Void(x:Float = -1.0)
		objective = OBJ_MOVE_TO_POINT_ON_TRAIN
		SetObjX(x)
		Print(objective)
	End Method

	Method ApplyMoveToPointOnTrain:Void()
		If (actor.x < objX)
			If (approachVectorX < 0.0) 'arrived
				StartSeekAndDestroy()
			Else
				actor.movingRight = True
			End If
		Else
			If (approachVectorX > 0.0) 'arrived
				StartSeekAndDestroy()
			Else
				actor.movingLeft = True
			End If
		End If
	End Method
	
		
	Method SelectNewTarget:Void()
		'TODO: adapt to multiple survivors?
		If (survivors[0].hp > 0.0)
			target = survivors[0]
		Else
			target = Null
		End If
	End Method
	
	Method SetObjX:Void(x:Float)
		If (x = -1.0)
			objX = Rnd(TRAIN_X_MIN, TRAIN_X_MAX)
		End If
		
		If (actor.x < objX)
			approachVectorX = 1.0
		Else
			approachVectorX = -1.0
		End If
	End Method
	
End Class