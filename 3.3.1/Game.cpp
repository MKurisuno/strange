#include "Game.h"
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_surface.h>
#include <SDL2/SDL_timer.h>
#include <SDL_audio.h>
#include <SDL_video.h>
#include <algorithm>
#include "Actor.h"
#include "Asteroid.h"
#include "Math.h"
#include "SpriteComponent.h"
#include "Ship.h"

Game::Game()
: mWindow(nullptr), mRenderer(nullptr), mIsRunning(true),mUpdatingActors(false)
{
	
}


bool Game::Initialize() {
	SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    mWindow = SDL_CreateWindow("GameProgramingC++ 3.3.1",
                               100, 100, 1024, 768, 0);
    mRenderer = SDL_CreateRenderer(mWindow, -1,
								   SDL_RENDERER_ACCELERATED |
									   SDL_RENDERER_PRESENTVSYNC);

    IMG_Init(IMG_INIT_PNG);
    // Error
    if (SDL_GetError() != nullptr) {
		SDL_Log("SDL_Error: %s.", SDL_GetError());
	}
    //Romdom::Init();
    LoadData();
    mTicksCount = SDL_GetTicks64();
    SDL_Log("Game::Initialize mTickCount = %ld.", mTicksCount);
    return true;
}


void Game::RunLoop() {
  //mIsRunning is initialize to be true at Game::Game()
  while (mIsRunning) {
	ProcessInput();
    UpdateGame();
    GenerateOutput();
  }
}

void Game::Shutdown() {
	//	UnloadData();
    IMG_Quit();
    SDL_DestroyRenderer(mRenderer);
    SDL_DestroyWindow(mWindow);
    SDL_Quit();

}

void Game::ProcessInput() {
	SDL_Event event;
    while (SDL_PollEvent(&event) != 0) {
		switch (event.type) {
		case SDL_QUIT:
			mIsRunning = false;
			break;
		default:
			break;
		}
    }
	
    const Uint8* keyState = SDL_GetKeyboardState(nullptr);
    if (keyState[SDL_SCANCODE_ESCAPE] != 0) {
		mIsRunning = false;
    }
	
    //Actor ProcessInput
    mUpdatingActors = true;
    for (auto* actor : mActors) {
		actor->ProcessInput(keyState);
		// Actor::ProcessInput(float deltatime)
		//   for( auto comp : mComponents){ comp->ProcessInput()}
		//   ActorInput()
    }
    mUpdatingActors = false;
    
}


void Game::AddActor(Actor* actor) {
  // If we're updating actors, need to add to pending
  //mUpdatingActors is initialized to be false at Game::Game()
  if (mUpdatingActors)
	  {
		  mPendingActors.emplace_back(actor);
	  }
  else
	  {
          mActors.emplace_back(actor);
	  }
}

void Game::RemoveActor(Actor *actor) {
	// Is it in pending Actor
	//    auto iter = std::find(mPendingActors.begin(),
	//                          mPendingActors.end(),
	//                          actor);
	auto iter = std::ranges::find(mPendingActors, actor);
	// Swap to end of vector and pop off (avoid erase copies)
	if (iter != mPendingActors.end()) {
		std::iter_swap(iter, mPendingActors.end() - 1);
		mPendingActors.pop_back();
	}
    // Is it in actors
    //iter = std::find(mActors.begin(), mActors.end(), actor);
	iter = std::ranges::find(mActors, actor);
	// Swap to end of vector and pop off (avoid erase copies)
    if (iter != mActors.end()) {
		std::iter_swap(iter, mActors.end());
		mActors.pop_back();
    }
}

void Game::AddSprite(SpriteComponent *sprite) {
	int myDrawOrder = sprite->GetUpdateOrder();

	auto iter = mSprites.begin();
	for (; iter != mSprites.end(); ++iter) {
		if (myDrawOrder < (*iter)->GetDrawOrder()) {
			break;
		}
	}
	mSprites.insert(iter,sprite);
}

void Game::RemoveSprite(SpriteComponent *sprite ) {
	//auto iter = std::find(mSprites.begin(), mSprites.end(), sprite);
	auto iter = std::ranges::find(mSprites, sprite);
	mSprites.erase(iter);
}

void Game::AddAsteroid(Asteroid* ast)
{
	mAsteroids.emplace_back(ast);
}

void Game::RemoveAsteroid(Asteroid* ast)
{
	auto iter = std::ranges::find(mAsteroids, ast);
	if(iter != mAsteroids.end())
		{
			mAsteroids.erase(iter);
		}
}

void Game::UpdateGame() {
	while (!SDL_TICKS_PASSED(SDL_GetTicks64(), mTicksCount + 16)) {
		SDL_Delay(1);
	}

	//float  deltatime = static_cast<float>( (SDL_GetTicks64() - mTicksCount) / 1000.0f );
	const Uint64 elapsedMilliseconds = SDL_GetTicks64() - mTicksCount;
	float deltatime = static_cast<float>(elapsedMilliseconds) / 1000.0F;

	//	if (deltatime >  0.05F) { deltatime = 0.05F;}
	deltatime = std::min(deltatime, 0.05F);

	mTicksCount = SDL_GetTicks64();
	
	mUpdatingActors = true;
	for (auto* actor : mActors) {
		//Actor::Update(){ UpdateComponent(); UpDateActor();}
		actor->Update(deltatime);
	}
	mUpdatingActors = false;
	
	for (auto* pending : mPendingActors) {
		mActors.emplace_back(pending)  ;
	}
	mPendingActors.clear();
	
	std::vector<Actor*> deadActors;
	for (auto* actor : mActors) {
		if (actor->GetState() == Actor::EDead) {
			deadActors.emplace_back(actor)  ;
		}
	}
	for (auto* actor : deadActors) {
		delete actor;
	}

}



void Game::GenerateOutput() 
{
	SDL_SetRenderDrawColor(mRenderer, 220,220,220,255);
	SDL_RenderClear(mRenderer);
	for(auto* sprite : mSprites){
		sprite->Draw(mRenderer);
	}
	SDL_RenderPresent(mRenderer);
}



void Game::LoadData() {
	// Create player's ship
	mShip = new Ship(this);
	mShip->SetPosition(Vector2(512.0F, 384.0F));
	mShip->SetRotation(Math::PiOver2);
	
	//Create asteroids
	const int numAsteriods = 20;
	for(int i = 0; i < numAsteriods; i++)
		{
			new Asteroid(this);
		}
}




// mTextures is decleared in Game.h which is
//                    std:unordered_map<std::string,SDL_Texture>
SDL_Texture* Game::GetTexture(const std::string &filename) {
	SDL_Texture *tex = nullptr;
  auto iter = mTextures.find(filename);
  if (iter != mTextures.end()) {
      return iter->second;
  } else {
    // Load from file.
    SDL_Surface *surf = IMG_Load(filename.c_str());
    if (surf != nullptr) {
      SDL_Log("Failed to Load texture file %s", filename.c_str());
      return nullptr;
    }
    tex = SDL_CreateTextureFromSurface(mRenderer, surf);
    SDL_FreeSurface(surf);
    if (tex != nullptr) {
      SDL_Log("Faild to convert surface to texture for %s", filename.c_str());
      return nullptr;
    }
      mTextures.emplace(filename.c_str(),tex);
  }
  return tex;
}

