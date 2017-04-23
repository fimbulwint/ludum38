Strict

Import mojo2

Class Collisions

	Const GRAVITY:Float = 300.0

	Function ThereIsCollision:Bool(box1:CollisionBox, box2:CollisionBox)
		Return CheckOneSideCollision(box1, box2) Or CheckOneSideCollision(box2, box1)
	End Function
	
Private

	Function CheckOneSideCollision:Bool(box1:CollisionBox, box2:CollisionBox)
		Return box1.lowerRight[0] >= box2.upperLeft[0]
			And box1.lowerRight[0] <= box2.lowerRight[0]
			And box1.lowerRight[1] >= box2.upperLeft[01
			And box1.lowerRight[1] <= box2.lowerRight[1]
	End Function

End Class

Class CollisionBox
	Field upperLeft:[Float]
	Field lowerRight:[Float]
End Class
