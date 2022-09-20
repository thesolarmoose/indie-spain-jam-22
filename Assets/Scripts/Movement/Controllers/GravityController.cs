using UnityEngine;

namespace Movement.Controllers
{
    public class GravityController : MovementControllerBase
    {
        [SerializeField] private float _gravityForce;
        [SerializeField] private float _minVerticalSpeed;
        [SerializeField] private float _maxVerticalSpeed;
        
        public override Vector2 Move(Vector2 previous)
        {
            float newValue = previous.y - _gravityForce;
            newValue = Mathf.Clamp(newValue, _minVerticalSpeed, _maxVerticalSpeed);
            
            previous.y = newValue;
            return previous;
        }
    }
}