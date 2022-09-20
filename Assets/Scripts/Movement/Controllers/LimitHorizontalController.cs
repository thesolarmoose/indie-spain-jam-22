using UnityEngine;

namespace Movement.Controllers
{
    public class LimitHorizontalController : MovementControllerBase
    {
        [SerializeField] private Transform _target;

        [SerializeField] private float _min;
        [SerializeField] private float _max;

        public float Min
        {
            get => _min;
            set => _min = value;
        }

        public float Max
        {
            get => _max;
            set => _max = value;
        }

        public override Vector2 Move(Vector2 previous)
        {
            float x = _target.position.x;
            float moveX = previous.x;

            if (x <= _min && moveX < 0)
            {
                previous.x = 0;
            }

            if (x >= _max && moveX > 0)
            {
                previous.x = 0;
            }

            return previous;
        }
    }
}