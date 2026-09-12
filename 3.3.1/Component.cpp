//
// Component is Called by class Actor. 
//
#include "Component.h"
#include "Actor.h"

Component::Component(Actor *owner, int updateorder)
: mOwner(owner), mUpdateOrder(updateorder)
{
	// AddComponent() add this to vector::mComponent in Class Actor
	mOwner->AddComponent(this);
}

Component::~Component() {
	//RemoceCOmponent remove this vector::mComponent in Actor.cpp
	mOwner->RemoveComponent(this);
}

void Component::Update(float deltatime) {}




