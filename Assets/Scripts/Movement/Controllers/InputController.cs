using Input;
using UnityEngine;

namespace Movement.Controllers
{
    public class InputController : MovementControllerBase
    {
        private GameInputActions _inputActions;

        public bool IsRunning
        {
            get
            {
                if (_inputActions != null)
                {
                    var value = _inputActions.Player.Move.ReadValue<Vector2>();
                    bool breaking = value.y > 0.1f;
                    bool lateralMove = Mathf.Abs(value.x) > 0.1f;
                    return breaking || lateralMove;
                }

                return false;
            }
        }

        private void OnEnable()
        {
            if (_inputActions == null)
            {
                _inputActions = new GameInputActions();
            }
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