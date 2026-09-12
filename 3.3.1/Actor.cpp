#include "Actor.h"
#include "Component.h"
#include "Game.h"
#include <algorithm>
#include <cstdint>
#include <sys/types.h>


Actor::Actor(Game *game)
    : mState(EActive), mPosition(Vector2::Zero), mScale(1.0f), mRotation(0.0f),
		mGame(game)
{
	mGame->AddActor(this);
}

Actor::~Actor() {
	mGame->RemoveActor(this);
}



void Actor::Update(float deltatime) {
	if (mState == EActive) {
		UpdateComponents(deltatime);
		UpdateActor(deltatime);
	}
}

void Actor::UpdateComponents(float deltatime) {
	for(auto comp :mComponents){
		comp->Update(deltatime);
	}
}

void Actor::UpdateActor(float deltatime) {
	
  
}



// mCompontnt is a Private Member of class Actor
// Component mComponent;
//
// Component::Component(Actor* owner, float deltatime)
//
void Actor::AddComponent(Component *component) {
	int myOrder = component->GetUpdateOrder();
	auto iter = mComponents.begin(); 
    for (; iter != mComponents.end(); ++iter) {
		if (myOrder < (*iter)->GetUpdateOrder()) {
			break;
		}
    }
    mComponents.insert(iter, component); 
                        //mComponent which is menber of class Actor
}

void Actor::RemoveComponent(Component *component) {
	auto iter = std::find(mComponents.begin(), mComponents.end(), component);
    if (iter != mComponents.end()) {
		mComponents.erase(iter);
    }
}


// keyState is called in class Game::ProcessInput
//    const Uint8* keyState = SDL_GetKeyboardState(NULL);
// Game::ProcessInput call actor->ProcessInput
//    for( auto actor : mActor ){ actor->ProcessInput(keyState);}
void Actor::ProcessInput(const uint8_t *keyState) {
	if (mState == EActive) {
		for (auto comp : mComponents) {
			comp->ProcessInput(keyState);
		}
		ActorInput(keyState);
	}
}

void Actor::ActorInput(const uint8_t *keyState) {
  
}
