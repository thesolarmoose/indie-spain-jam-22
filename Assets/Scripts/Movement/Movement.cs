﻿using System;
 using UnityEngine;

 namespace Movement
{
    public class Movement : MonoBehaviour
    {
        [SerializeField] private float speed;
    
        private Rigidbody2D _rb;
        
        public float Speed => speed;


        private Vector3 _lastPos;
        private void Update()
        {
            var pos = transform.position;
            var delta = pos - _lastPos;
//            print($"delta move {delta}");
            _lastPos = pos;
        }

        private void Awake()
        {
            _rb = GetComponent<Rigidbody2D>();
        }

        public void Move(Vector2 dir)
        {
            if (!enabled)
                return;
            _rb.velocity = dir * speed;
        }

        public void Stop()
        {
            Move(Vector2.zero);
        }
    }
}