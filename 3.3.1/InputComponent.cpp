#include "InputComponent.h"
#include "Actor.h"
#include "MoveComponent.h"
#include <SDL2/SDL_scancode.h>
#include <cstddef>
#include <cstdint>

// InputComponent(Actor* owner)
//        mMaxForwardSpeed   
//        mMaxAngularSpeed
//          <-- MoveComponent(Actor* owner)
//               mAngularSpeed
//               mForwardSpeed
//             <-- Component(Actor* owner, updateOrder)
//                 mUpdateOrder
    
InputComponent::InputComponent(class Actor *owner)
    : MoveComponent(owner),
      mForwardKey(SDL_SCANCODE_UNKNOWN),
      mBackKey(0),
      mClockwiseKey(0),
      mCounterClockwiseKey(0)
    {
  
}


void InputComponent::ProcessInput(const uint8_t *keyState) {

  float forwordSpeed = 0.0f;
  if (keyState[mForwardKey]) {
      forwordSpeed += mMaxForwardSpeed;
  }if (keyState[mBackKey]) {
       forwordSpeed -= mMaxForwardSpeed;
   }
  // Declared in class MoveComponent.
  // SetForwardSpeed(float speed) { mForwardSpeed = speed; }
  SetForwardSpeed(forwordSpeed); 
  
  float angularSpeed = 0.0f;
  if (keyState[mClockwiseKey]) {
      angularSpeed += mMaxAngularSpeed;
  }if (keyState[mCounterClockwiseKey]) {
       angularSpeed -= mMaxAngularSpeed;
   }
  // Declared in class MoveComponent.
  // SetAngularSpeed(float speed) { mAngularSpeed = speed; }
  SetAngularSpeed(angularSpeed); //// declared in class MoveComponent.
  
  }
