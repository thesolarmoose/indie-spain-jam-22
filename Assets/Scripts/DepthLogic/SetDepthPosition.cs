using System;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DepthLogic
{
    public class SetDepthPosition : MonoBehaviour
    {
        [SerializeField] private float _depth;
        [SerializeField] private FloatVariable _depthScale;

        private void Start()
        {
            var pos = transform.position;
            pos.y = -_depth * _depthScale.Value;
            transform.position = pos;
        }
    }
}