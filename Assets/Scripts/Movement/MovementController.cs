using System;
using System.Collections.Generic;
using NaughtyAttributes;
using UnityEngine;

namespace Movement
{
    public class MovementController : MonoBehaviour
    {
        [SerializeField] private Movement _movement;
        [SerializeField] private List<MovementControllerBase> _controllersChain;
        
        private void Move()
        {
            Vector2 movement = Vector2.zero;
            foreach (var controller in _controllersChain)
            {
                if (controller.enabled && controller.gameObject.activeInHierarchy)
                {
                    movement = controller.Move(movement);
                }
            }

            _movement.Move(movement);
        }

        private void Update()
        {
            Move();
        }
    }
}