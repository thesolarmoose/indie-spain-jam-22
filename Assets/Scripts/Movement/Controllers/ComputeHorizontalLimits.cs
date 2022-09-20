using System;
using UnityEngine;
using Utils.Attributes;

namespace Movement.Controllers
{
    public class ComputeHorizontalLimits : MonoBehaviour
    {
        [SerializeField, AutoProperty(AutoPropertyMode.Scene)]
        private Camera _camera;

        [SerializeField] private float _halfSubmarineSize;
        [SerializeField] private LimitHorizontalController _controller;

        private void Start()
        {
            ComputeLimits();
        }

        private void ComputeLimits()
        {
            float halfHeight = _camera.orthographicSize;
            float halfWidth = _camera.aspect * halfHeight;
            float limit = halfWidth - _halfSubmarineSize;

            _controller.Min = -limit;
            _controller.Max = limit;
        }
    }
}