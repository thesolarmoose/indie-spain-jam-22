using UnityEngine;

namespace Movement
{
    public abstract class MovementControllerBase : MonoBehaviour
    {
        public abstract Vector2 Move(Vector2 previous);
    }
}