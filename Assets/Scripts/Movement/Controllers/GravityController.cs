using UnityEngine;

namespace Movement.Controllers
{
    public class GravityController : MovementControllerBase
    {
        [SerializeField] private float _gravityForce;
        
        public override Vector2 Move(Vector2 previous)
        {
            previous.y = -_gravityForce;
            return previous;
        }
    }
}