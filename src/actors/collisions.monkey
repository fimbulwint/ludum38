Strict

Import mojo2

Class Collisions

	Const GRAVITY:Float = 300.0

	Function ThereIsCollision:Bool(box1:CollisionBox, box2:CollisionBox)
	
'		Print("B1 LR X")
'		Print(box1.lowerRight[0])
'		Print("B1 LR Y")
'		Print(box1.lowerRight[1])
'		
'		Print("B1 UL X")
'		Print(box1.upperLeft[0])
'		Print("B1 UL Y")
'		Print(box1.upperLeft[1])
'		
'		Print("B2 LR X")
'		Print(box2.lowerRight[0])
'		Print("B2 LR Y")
'		Print(box2.lowerRight[1])
'		
'		Print("B2 UL X")
'		Print(box2.upperLeft[0])
'		Print("B2 UL Y")
'		Print(box2.upperLeft[1])
	
		Return CheckOneSideCollision(box1, box2) Or CheckOneSideCollision(box2, box1)
	End Function
	
Private

	Function CheckOneSideCollision:Bool(box1:CollisionBox, box2:CollisionBox)
		Return box1.lowerRight[0] >= box2.upperLeft[0] And box1.lowerRight[0] <= box2.lowerRight[0] And box1.lowerRight[1] >= box2.upperLeft[1] And box1.lowerRight[1] <= box2.lowerRight[1]
		Return True
	End Function

End Class

Class CollisionBox
	Field upperLeft:Float[]
	Field lowerRight:Float[]
	
	Method New(upperLeft:Float[], lowerRight:Float[])
		Self.upperLeft = upperLeft
		Self.lowerRight = lowerRight
	End
End Class
