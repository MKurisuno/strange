// ----------------------------------------------------------------
// From Game Programming in C++ by Sanjay Madhav
// Copyright (C) 2017 Sanjay Madhav. All rights reserved.
// 
// Released under the BSD License
// See LICENSE in root directory for full details.
// ----------------------------------------------------------------

#include "MoveComponent.h"
#include "Actor.h"

MoveComponent::MoveComponent(class Actor* owner, int updateOrder)
:Component(owner, updateOrder)
,mAngularSpeed(0.0F)
,mForwardSpeed(0.0F)
{
	
}

void MoveComponent::Update(float deltaTime)
{
	if (!Math::NearZero(mAngularSpeed))
	{
		float rot = mOwner->GetRotation(); // return 'class Actor float mRotation'
		rot += mAngularSpeed * deltaTime;
		mOwner->SetRotation(rot);  // Set class Actor float mRotation 
	}
	
	if (!Math::NearZero(mForwardSpeed))
	{
		Vector2 pos = mOwner->GetPosition();
		pos += mOwner->GetForward() * mForwardSpeed * deltaTime;
		
		// (Screen wrapping code only for asteroids)
		if (pos.x < 0.0F) { pos.x = 1022.0F; }
		else if (pos.x > 1024.0F) { pos.x = 2.0F; }

		if (pos.y < 0.0F) { pos.y = 766.0F; }
		else if (pos.y > 768.0F) { pos.y = 2.0F; }

		mOwner->SetPosition(pos);
	}
}
