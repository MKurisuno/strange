//
// class Component must be Called by class Actor.
//
#pragma once
#include <cstdint>

class Component {
 public :
  Component(class Actor *owner, int updateorder = 100);
  virtual ~Component();
  virtual void Update(float deltatime);
  virtual void ProcessInput(const uint8_t *keyState) {}
  int GetUpdateOrder() const { return mUpdateOrder; }
  
 protected:
  class Actor *mOwner;
  int  mUpdateOrder; //Component::Component() で初期化
                     //mUpdateOrder(updateorder)
};
