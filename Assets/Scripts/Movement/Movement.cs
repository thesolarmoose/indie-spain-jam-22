﻿using System;
 using UnityEngine;

 namespace Movement
{
    public class Movement : MonoBehaviour
    {
        [SerializeField] private float speed;
    
        private Rigidbody2D _rb;
        
        public float Speed => speed;

        private void Awake()
        {
            _rb = GetComponent<Rigidbody2D>();
        }

        public void Move(Vector2 dir)
        {
            if (!enabled)
                return;
            _rb.velocity = dir * speed;

            var scale = transform.localScale;
            if (dir.x > 0)
            {
                scale.x = 1;
            }
            if (dir.x < 0)
            {
                scale.x = -1;
            }

            transform.localScale = scale;
        }

        public void Stop()
        {
            Move(Vector2.zero);
        }
    }
}