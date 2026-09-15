#include "Laser.h"
#include "Actor.h"
#include "Asteroid.h"
#include "MoveComponent.h"
#include "SpriteComponent.h"
#include "Game.h"
#include "CircleComponent.h"


Laser::Laser(Game* game):Actor(game),mDeathtimer(1.0F)
{
	//Create Sprite Component 
	auto* sc = new SpriteComponent(this);
	sc->SetTexture(game->GetTexture("Assets/Laser.png"));
	//Create a move Component
	auto* mc = new MoveComponent(this);
	mc->SetForwardSpeed(800.0F);
	//Create a circle Component for collision.
	mCircle = new CircleComponent(this);
	mCircle->SetRadius(11.0F);

}

void Laser::UpdateActor(float deltatime){
	mDeathtimer -= deltatime;
	if(mDeathtimer <= 0.0F){
		SetState(EDead);
	}
	else { // collision 
		for(auto* ast : GetGame()->GetAsteroids()){
			if(Intersect(*mCircle,*(ast->GetCircle()) ))
				{
					SetState(EDead);
					ast->SetState(EDead);
					break;
				}
		}
	}

}
