#include "Asteroid.h"
#include "Actor.h"
#include "Math.h"
#include "MoveComponent.h"
#include "SpriteComponent.h"
#include "Game.h"
#include "Random.h"
#include "CircleComponent.h"


Asteroid::Asteroid(Game* game )
:Actor(game),mCircle(nullptr)
{
// Initialize to random position/orienntation 
Vector2 randPos = Random::GetVector(Vector2::Zero, Vector2(1024,768));
SetPosition(randPos);
SetRotation(Random::GetFloatRange(0.0F,Math::TwoPi));

//Create a sprite component
auto* sPcOmp  = new SpriteComponent(this);
sPcOmp->SetTexture(game->GetTexture("Assets/Asteroid.png"));

//Create MovementConponent, and set a forward speed
auto* mOveComp = new MoveComponent(this);
mOveComp->SetForwardSpeed(150.0F);

//Create a cicle component
mCircle = new CircleComponent(this);
mCircle->SetRadius(40.0F);

//Addto mAsteroids 
game->AddAsteroid(this);

}

Asteroid::~Asteroid()
{
GetGame()->RemoveAsteroid(this);
}

