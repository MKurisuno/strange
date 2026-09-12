#include "CircleComponent.h"
#include "Actor.h"
#include "Math.h"

CircleComponent::CircleComponent(class Actor* owner)
:Component(owner)
	,mRadius(0.0f)
{
}


const Vector2& CircleComponent::GetCenter() const 
{
	return mOwner->GetPosition();
}

float CircleComponent::GetRadius() const
{
	return mOwner->GetScale() * mRadius ;
}



bool Intersect(const CircleComponent& a , const CircleComponent& b)
{
	//距離の2乗を計算
	Vector2 diff = a.GetCenter() - b.GetCenter(); 
	float distSq = diff.LengthSq();
	//2個のObjectの距離の2乗を計算
	float radiiSq = a.GetRadius() - b.GetRadius();
	radiiSq *= radiiSq; 
	return distSq <= radiiSq;
}

