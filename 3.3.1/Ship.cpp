#include "Ship.h"
#include "Game.h"
#include "SpriteComponent.h"
#include "InputComponent.h"
#include <SDL2/SDL_scancode.h>

Ship::Ship(Game* game )
:Actor(game)
//,mLaserCooldown(0.0f)
{

	//Create Sprite Component
	auto* sc = new SpriteComponent(this, 150);
	sc->SetTexture(game->GetTexture("Assets/Ship.png"));
	
	//Create Input Component
	auto* ic = new InputComponent(this);
	ic->SetForwardKey(SDL_SCANCODE_W);
	ic->SetBackKey(SDL_SCANCODE_S);
	ic->SetClockwiseKey(SDL_SCANCODE_A);
	ic->SetCounterClockwiseKey(SDL_SCANCODE_D);
	ic->SetMaxForwardSpeed(300.0f);
	ic->SetMaxAngularSpeed(Math::TwoPi);
}

void Ship::UpdateActor(float deltatime)
{
	mLaserCooldown -= deltatime;
}

void Ship::ActorInput( const uint8_t* keyState){
	if(keyState[SDL_SCANCODE_SPACE] && mLaserCooldown <= 0.0f)	{
	

		mLaserCooldown = 0.5f;
	}

}
