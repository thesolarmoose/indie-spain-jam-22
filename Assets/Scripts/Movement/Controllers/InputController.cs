using Input;
using UnityEngine;

namespace Movement.Controllers
{
    public class InputController : MovementControllerBase
    {
        private GameInputActions _inputActions;

        private void Start()
        {
            _inputActions = new GameInputActions();
            _inputActions.Enable();
        }

        private void OnEnable()
        {
            _inputActions?.Enable();
        }

        private void OnDisable()
        {
            _inputActions?.Disable();
        }

        public override Vector2 Move(Vector2 previous)
        {
            var value = _inputActions.Player.Move.ReadValue<Vector2>();
            if (value.y > 0)
            {
                value.y = 0;
            }
            else
            {
                value.y = previous.y;
            }
            
            return value;
        }
    }
}